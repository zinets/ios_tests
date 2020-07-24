//
//  FullScreenController.swift
//  mdukProfileProto
//
//  Created by Victor Zinets on 8/7/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit
import DiffAble

/*  КрасивыйФулСкринКонтроллер usage:
    создать контроллер
    let destination = UIStoryboard(name: "FullScreenController", bundle: nil).instantiateViewController(withIdentifier: "FullScreenController") as! FullScreenController
    destination.startImage = картинка, из которой переходим, берем ее например из sender
    let sourceFrame = фрейм стартовой картинки, например координаты мелкого квадратика в координатах экрана - потому что переходим в фулскрин
    destination.startFrame = sourceFrame
    destination.currentIndex = 3 - например хотим сразу открыть скроллер на 4й картинке
    destination.onIndexChanged = { [unowned destination, unowned self] (newIndex) in
        при прокрутке фото в фулскрине можно синхронизировать что-то с этим изменением
    }
    destination.getFullscreenData = { нужно назначить блок, который будет возвращать итемы для показа, см. коммент ниже про "придумать лучшее название для блока"
 
    destination.decorationView = если надо оверлей над скролером - создать вью, настроить и передать; все обработки контролов этого вью делаются в контролере, который вызывает фулскрин
 
    destination.transitioningDelegate = destination // DONE: почему не сделать эту настройку безусловной в самом контроллере FS?
    navrouter().present(destination, animated: true, completion: nil)
    презентим, потому что делегирование предполагает именно презент, для пуша я не пробовал и не проверял и не делал и вообще
*/

// TODO: confirm SuppressNotifications

class FullScreenController: UIViewController {

    // MARK: - outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    // договариваемся: для того, чтобы красиво перейти В фулскрин, надо передать следующие параметры перед показом
    /// стартовый фрейм, откуда переходим в ФС; при этом предполагаем, что картинка будет scaleToFill - логичнее всего, у нас ячейки в профиле/сорче/etc заполняются именно так, чтобы не было дырок по бокам
    var startFrame: CGRect!
    /// картинка, из которой (и в которую) мы переходим; в конце предполагаем, что картинка будет вписана scaleToFit - логично видеть при переходе в фулскрин картинку полностью
    var startImage: UIImage!
    
    /// некрасиво, но т.к. много где скругления налево и направо, то тулить отдельно аниматор для этого глупо; кроме того, есть случаи, где скругление "условное" - поэтому..
    /// аниматор может принять во внимание значение этой переменной и использовать его для скругления анимирующейся картинки
    var proposedCornerRadius: CGFloat?
    
    // TODO: придумать лучшее название для блока
    /// смысл в том, что этот блок задается на стороне "заказчика", кода, который хочет показать свои фотки в фулскрине (профили, переписки) - они по своей и бизнес логеках создают массив из FullScreenCellItem и возвращают в этом блоке; в элементе для показа может присутствовать additionalData: AnyObject? - туда пихаем все, что нужно кастомным ячейкам для своей настройки (например userInfo для блура - показать поверх блура аватар юзера)
    var getFullscreenData: (() -> [FullScreenItem])?
    func setNeedsUpdate() {
        if let block = self.getFullscreenData {
            let newItems = block()
            self.dataSource.beginUpdates()
            self.dataSource.appendSections([.single])
            self.dataSource.appendItems(newItems.map{ AnyDiffAble($0) }, toSection: .single)
            self.dataSource.endUpdates()
            
//            self.dataSource.items = block()
        }
    }
    
    // допустим контроллер будет хранить (и сам с этим ничего не делать! но це не точно теперь) блоки для "до/после показа" и "до/после возврата"
    var beforeAppear: (() -> Void)?
    var afterAppear: (() -> Void)?
    
    var beforeDisappear: (() -> Void)?
    var afterDisappear: (() -> Void)?
    
    private var index: Int?
    var currentIndex: Int? {
        get {
            guard self.isViewLoaded else {
                return nil
            }
            let contentOffset = self.collectionView.contentOffset
            return Int((contentOffset.x / self.collectionView.bounds.width).rounded())
        }
        set {
            index = newValue
            guard self.isViewLoaded, newValue != nil else {
                return
            }
            // очевидно, что все похерится, если bounds коллекции поменяется; или нет? у меня же включена пажинация..
            let contentOffset = CGPoint(x: CGFloat(newValue!) * self.collectionView.bounds.width, y: 0)
            self.collectionView.setContentOffset(contentOffset, animated: false)
            let numberOfItems = self.dataSource.itemsCount(for: .single) //self.dataSource.items.count
            if let block = onIndexChanged {
                block(newValue!, numberOfItems)
            }
        }
    }
    
    var currentImage: UIImage? {
        // тут предположение, что а) уже все размеры давно устаканились, картинка нужна при уходе с фулскрина б) на экране одно фото за раз (так что теоретически можно скрольнуть и успеть закрыть фулскрин)
        if let cell = self.collectionView.visibleCells.first as? FullScreenPhotoCell {
            return cell.currentImage
        // TODO: video support
//        } else if let cell = self.collectionView.visibleCells.first as? FullScreenVideoCell {
//            // это ненормально, но сойдет; лучче, если хоть какая-то картинка анимируется "назад", чем никакая..
//            let renderer = UIGraphicsImageRenderer(bounds: cell.bounds)
//            let image = renderer.image { (_) in
//                cell.drawHierarchy(in: cell.bounds, afterScreenUpdates: false)
//            }
//            return image
        }
        
        return nil
    }
    
    var currentZoom: CGFloat? {
        guard let cell = self.collectionView.visibleCells.first as? FullScreenPhotoCell else {
            return nil
        }
        
        return cell.currentZoomScale
    }
    
    // TODO: переделать на передачу 2х параметров - индекс и кол-во
    var onIndexChanged: ((Int, Int) -> Void)?
    var onFullscreenExit: (() -> Void)?
    
    /// Вью широкого назначения, пусть его сделает кто-то, а я положу здесь поверх; соотв. пусть оно будет сообразительным и не блокирует гестуры, а только разрешает своим кнопкам - или что там в нем будет - отрабатывать
    ///
    /// Соотв. чтобы было всем проще это вью наложится поверх всего контроллера, а расположение кнопок/контролов внутри пусть парит того, кто вью делает
    ///
    /// Индикатора прокрутки тут не будет; чтобы разнообразить диз, потому что какая универсальность, если индикаторы могут быть другими? значит - индикатор прокрутки, как бы он не выглядел, должен быть частью decorationView
    ///
    /// для кода несущественно, но в сториборде при создании нужно указать, что используется класс FullscreenDecorationView (это важно)
    var decorationView: UIView? {
        didSet {
            if let view = oldValue {
                view.removeFromSuperview()
            }
        }
    }
      
    
    // MARK: - datasource
    private lazy var dataSource: CollectionDiffAbleDatasource<DiffAbleSection, AnyDiffAble> = {
        return CollectionDiffAbleDatasource<DiffAbleSection, AnyDiffAble>(collectionView: self.collectionView, cellConfigurator: { ($0 as! AnyDiffAbleControl).configure($1) })
    }()
            
    // MARK: - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.transitioningDelegate == nil {
            self.transitioningDelegate = self
        }
        
        self.setNeedsUpdate()
        
        if let index = self.index {
            currentIndex = index
        }
    }
    
//    deinit {
//        print(#function)
//    }
    
    private var statusBarVisible = true {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return !statusBarVisible
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let view = self.decorationView {
            view.frame = self.view.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(view)
            
            view.alpha = 0
        }
        statusBarVisible = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // внимания! код был в viewDidLayoutSubviews, но я перенес его сюда
        let contentOffset = CGPoint(x: CGFloat(index ?? 0) * self.collectionView.bounds.width, y: 0)
        self.collectionView.setContentOffset(contentOffset, animated: false)
        // потому что пол-дня искал причину подергивания при скроле 1й фото
        // код нужен и здесь вроде работает без вопросов - но мало ли
        
        UIView.animate(withDuration: 0.25) {
            self.decorationView?.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        statusBarVisible = true
    }
    
    // MARK: - actions
    @IBAction func close(_ sender: Any) {
        decorationView?.alpha = 0

        self.dismiss(animated: true, completion: {
            if let block = self.beforeDisappear {
                block()
            }
            let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
                if let block = self.afterDisappear {
                    block()
                }
            }
            animator.startAnimation()
        })        
        
        if let block = self.onFullscreenExit {
            block()
        }
    }
    
    // допустим у меня будут свойства с нужным аниматором, а если не задан - буду создавать какой-то "дефолтный"
    var presentAnimator: UIViewControllerAnimatedTransitioning?
    var dismissAnimator: UIViewControllerAnimatedTransitioning?
    
    // а с интерактивностью я пока не хочу играться
    private let driver = TransitionDriver()

}

extension FullScreenController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        driver.link(to: presented)
        
        let presentationController = FullscreenPresentationController(presentedViewController: presented,presenting: presenting ?? source)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = presentAnimator else {
            return FullScreenPresentAnimator()
        }
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = presentAnimator else {
            return FullScreenDismissAnimator()
        }
        return animator
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }

}


extension FullScreenController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let index = self.currentIndex {
            let numberOfItems = self.dataSource.itemsCount(for: .single)
            if let block = self.onIndexChanged {
                block(index, numberOfItems)
            }
        }
//        let index = Int((scrollView.contentOffset.y / scrollView.bounds.height).rounded())
//        if let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? FullScreenVideoCell {
//            cell.play()
//        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let index = Int((scrollView.contentOffset.y / scrollView.bounds.height).rounded())
//        if let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? FullScreenVideoCell {
//            cell.pause()
//        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}


