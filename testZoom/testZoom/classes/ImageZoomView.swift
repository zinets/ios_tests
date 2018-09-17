//
//  ImageZoomView.swift
//

import UIKit

/* контрол для просмотра с зумом картинок
 
 usage - загрузка картинки
 
 @IBAction func loadImage(_ sender: Any) {
    let image = UIImage(named: "zoomTest.jpg")
    // контрол лежит на вью с констрейнтами на все стороны
 
    scrollView.image = image
    scrollView.zoomEnabled = true
    // загрузили картинку и заполнили ею контент - типичный вариант - ячейки поиска, ячейки в профиле, т.к. картинка без полос
    scrollView.contentMode = .scaleAspectFill
 }
 
 ресайз контрола - с анимацией и изменением типа заполнения с "залить" на "вписать" - например видим квадратный контрол с фото, после увеличения на весь экран картинка "вписывается" в контрол, чтобы полностью показаться, при этом возможно появления полос
 
    sender.isSelected = !sender.isSelected
    UIView.animate(withDuration: 0.5) {
 
        if sender.isSelected {  // "фулскрин"
            self.heightC.constant = 600
            self.leftC.constant = 0
            self.rightC.constant = 0

            self.view.layoutIfNeeded()
            self.scrollView.contentMode = .scaleAspectFit
        } else {                // отдельный контрол
            self.heightC.constant = 250
            self.leftC.constant = 40
            self.rightC.constant = 40

            self.view.layoutIfNeeded()
            self.scrollView.contentMode = .scaleAspectFill
        }
    }
 
 можно раскомментировать фичу изменение зума до "показать все" по 2му тапу
 */

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    var index: Int = 0
    
    var zoomEnabled = false
    private var viewToZoom = UIImageView()
//    private lazy var dblTapGesture: UITapGestureRecognizer = {
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dblTapAction(_:)))
//        recognizer.numberOfTapsRequired = 2
//        recognizer.isEnabled = false
//
//        return recognizer
//    }()
    
    override open var contentMode: UIViewContentMode {
        didSet {
            scalesForZooming()
        }
    }
    
    var topAlignedAspectFill: Bool = true {
        didSet {
            scalesForZooming()
        }
    }
    
    private func commonInit() {
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    var image: UIImage? {
        willSet {
            viewToZoom.removeFromSuperview()
//            dblTapGesture.isEnabled = false
        }
        didSet {
            viewToZoom = UIImageView(image: image)
            viewToZoom.isUserInteractionEnabled = true
//            imageView.addGestureRecognizer(dblTapGesture)
//            dblTapGesture.isEnabled = true
            self.addSubview(viewToZoom)
            
            scalesForZooming()
        }
    }
    
    private var restorePoint: CGPoint!
    private var restoreScale: CGFloat!
    
    // todo - без этого оверрайда можно обойтись, если меняем размеры в коде? имхо нет
    override var frame: CGRect {
        willSet {
            restorePoint = self.pointToCenter()
            restoreScale = self.scaleToRestore()
        }
        didSet {
            self.scalesForZooming()
            self.restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
        }
    }

    // изменение bounds срабатывает при изменении констрейнтов - но оно же срабатывает при зуме/скроле, поэтому это не тот случай.. хотя..
    override var bounds: CGRect {
        willSet {
            if newValue.size != bounds.size {
                restorePoint = self.pointToCenter()
                restoreScale = self.scaleToRestore()
            }
        }
        didSet {
            if oldValue.size != bounds.size {
                self.scalesForZooming()
                self.restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
            }
        }
    }
    
    // MARK: zoooming -
    
    // это самый пока работающий способ - отключать зум для контрола; немного хак, т.к. явно нигде не говорится, что этот класс (наследник от скролВью) - делегат для своих скролеров; но override работает без вопросов
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPinchGestureRecognizer {
            return zoomEnabled
        }
        if gestureRecognizer is UIPanGestureRecognizer {
            return zoomEnabled
        }
        return true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewToZoom
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerViewForZooming()
    }
    
    private func scalesForZooming() {
        if let image = image {
            self.contentSize = image.size
            if index == 2 {
                print("stop")
            }
            let scaleX = self.bounds.size.width / self.contentSize.width
            let scaleY = self.bounds.size.height / self.contentSize.height
            let scaleToFit = min(scaleX, scaleY)
            let scaleToFill = max(scaleX, scaleY)
            
            self.minimumZoomScale = self.contentMode == .scaleAspectFill ? scaleToFill : scaleToFit
            self.maximumZoomScale = 1
            self.zoomScale = self.minimumZoomScale
            
            centerViewForZooming()
        }
    }
    
    private func centerViewForZooming() {
        let boundsSize = self.bounds.size
        var contentFrame = viewToZoom.frame
        var contentOffset = CGPoint.zero
        
        if contentFrame.size.width < boundsSize.width {
            contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2
        } else {
            contentFrame.origin.x = 0
            contentOffset.x = (contentFrame.size.width - boundsSize.width) / 2
        }
        
        if contentFrame.size.height < boundsSize.height {
            contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2
        } else {
            contentFrame.origin.y = 0
            if contentMode == .scaleAspectFill && topAlignedAspectFill {
                contentOffset.y = 0
            } else {
                contentOffset.y = (contentFrame.size.height - boundsSize.height) / 2
            }
        }

        viewToZoom.frame = contentFrame
        self.contentOffset = contentOffset
    }
    
    private func pointToCenter() -> CGPoint {
        let boundsCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        return self.convert(boundsCenter, to: viewToZoom)
    }

    private func scaleToRestore() -> CGFloat {
        var contentScale = self.zoomScale
        if contentScale <= self.minimumZoomScale + CGFloat.ulpOfOne {
            contentScale = 0
        }
        return contentScale
    }
    
    private func maximumContentOffset() -> CGPoint {
        let contentSize = self.contentSize
        let boundSize = self.bounds.size
        return CGPoint(x: contentSize.width - boundSize.width,
                       y: contentSize.height - boundSize.height)
    }
    
    private func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }
    
    private func restoreCenterPoint(to oldCenter: CGPoint, oldScale: CGFloat) {
        self.zoomScale = min(self.maximumZoomScale, max(self.minimumZoomScale, oldScale))
        
        let boundsCenter = self.convert(oldCenter, from: viewToZoom)
        var offset = CGPoint(x: boundsCenter.x - self.bounds.size.width/2.0,
                             y: boundsCenter.y - self.bounds.size.height/2.0)
        let maxOffset = self.maximumContentOffset()
        let minOffset = self.minimumContentOffset()
        offset.x = max(minOffset.x, min(maxOffset.x, offset.x))
        offset.y = max(minOffset.y, min(maxOffset.y, offset.y))
        
        self.contentOffset = offset
    }
    
    // MARK: dbl tap to zoom -

//    @objc func dblTapAction(_ sender: Any) {
//        if zoomEnabled {
//            zoomScale = minimumZoomScale
//        }
//    }
    
}

