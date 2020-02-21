//
//  CollectionViewPagingLayout.swift
//

import UIKit

/**
 идеи
 
 раскладка трансформирует ленту ячеек, горизонтальную или вертикальную, в собственно все такой же набор аттрибутов с дополнением - параметром progress, который показывает положение каждой ячейки относительно текущего "видимого" окна коллекции
 
 т.е. все ячейки к примеру могут иметь примерно одинаковые фреймы, но параметр progress может визуально трансформировать ячейку; или ячейки могут лежать согласно flow раскладке, но параметр progress может использоваться для паралакса; прокрутка коллекции может вызывать "смахивание" ячейки или например ее вращение относительно вертикальной оси etc
 
 предполагается, что размер ячейки == размеру фрейма коллекции; для простоты вычисления currentIndex
 как вариант можно переделать на определение ячейки в геометрическом центре коллекции (сортировка по расстоянию по x  или y в зависимости от направления скрола) и возврата ее индекса
 
 очевидно, что поддерживается только одна секция
 */

public protocol CollectionViewProgressiveLayoutDelegate: class {
    func onCurrentPageChanged(layout: CollectionViewProgressiveLayout, currentPage: Int)
}

// аттрибуты для ячейки с поддержкой свойства progress - которое может использоваться а) для паралакса к примеру ?) для трансформаций при прокрутке
class CollectionViewProgressLayoutAttributes: UICollectionViewLayoutAttributes {
    var progress: CGFloat = 0
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        guard object.progress == progress else {
            return false
        }
        return super.isEqual(object)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! Self
        copy.progress = progress
        
        return copy
    }
}

public class CollectionViewProgressiveLayout: UICollectionViewFlowLayout {
    
    public override class var layoutAttributesClass: AnyClass {
        return CollectionViewProgressLayoutAttributes.self
    }
    
    // MARK: properties -
    weak var delegate: CollectionViewProgressiveLayoutDelegate?
    override public var scrollDirection: UICollectionView.ScrollDirection {
        didSet {
            self.invalidateLayout()
        }
    }
    
    // DONE: это справедливо только для случаев, когда стопка (т.е. все ячейки видны сразу) - сделать универсальнее
    // нет; нам нужен гипотетический размер контента чтобы вычислять значение progress для каждой ячейки из ее положения в этом гипотетическом пространстве
    override public var collectionViewContentSize: CGSize {
        let safeAreaLeftRight = (collectionView?.safeAreaInsets.left ?? 0) + (collectionView?.safeAreaInsets.right ?? 0)
        let safeAreaTopBottom = (collectionView?.safeAreaInsets.top ?? 0) + (collectionView?.safeAreaInsets.bottom ?? 0)
        // TODO: добавить в рассчет добавленные инсеты? например для дизайна, когда первая/последняя ячейки должны быть всегда в центре, это делается инсетами сбоку..
        if self.scrollDirection == .horizontal {
            return CGSize(width: CGFloat(numberOfItems) * visibleRect.width - safeAreaLeftRight, height: visibleRect.height - safeAreaTopBottom)
        } else {
            return CGSize(width: visibleRect.width - safeAreaLeftRight, height: CGFloat(numberOfItems) *  visibleRect.height - safeAreaTopBottom)
        }
    }
    
    private(set) var currentPage: Int = 0
    
    fileprivate var visibleRect: CGRect {
        guard let collectionView = collectionView else {
            return .zero
        }
        return CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
    }
        
    private var numberOfItems: Int {
        collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    
    // MARK: Public functions -
    public func setCurrentPage(_ page: Int, animated: Bool = true) {
        if self.scrollDirection == .horizontal {
            var offset = visibleRect.width * CGFloat(page)
            offset = min(collectionViewContentSize.width - visibleRect.width, max(0, offset))
            collectionView?.setContentOffset(.init(x: offset, y: 0), animated: animated)
        } else {
            var offset = visibleRect.height * CGFloat(page)
            offset = min(collectionViewContentSize.height - visibleRect.height, max(0, offset))
            collectionView?.setContentOffset(.init(x: 0, y: offset), animated: animated)
        }
    }
    
    public func goToNextPage(animated: Bool = true) {
        setCurrentPage(currentPage + 1, animated: animated)
    }
    
    public func goToPrevPage(animated: Bool = true) {
        setCurrentPage(currentPage - 1, animated: animated)
    }
    
    // MARK: UICollectionViewFlowLayout -
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // TODO: вот тут точно разделить вычисление прогресса и фрейма (а как?.. а вот думай)
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attrs = super.layoutAttributesForElements(in: rect) as? [CollectionViewProgressLayoutAttributes] else {
            return nil
        }
        
        return attrs.map { (item) -> CollectionViewProgressLayoutAttributes in
            let indexPath = item.indexPath
            let progress = CGFloat(indexPath.item) - (self.scrollDirection == .horizontal ? visibleRect.minX / visibleRect.width : visibleRect.minY / visibleRect.height)
            item.progress = progress
            
//            item.frame = visibleRect
//            item.zIndex = Int(-abs(round(progress)))
//            item.isHidden = abs(progress) > 1 // TODO: и/или если индекс карточки > видимого кол-ва карточек
            
            return item
        }
    }
    
    override public func invalidateLayout() {
        super.invalidateLayout()
        updateCurrentPageIfNeeded()
    }
    
    // MARK: Private functions -
    private func updateCurrentPageIfNeeded() {
        var currentPage: Int = 0
        if let collectionView = collectionView {
            let pageWidth = self.scrollDirection == .horizontal ? collectionView.frame.width : collectionView.frame.height
            let contentOffset = self.scrollDirection == .horizontal ? (collectionView.contentOffset.x + collectionView.contentInset.left) : (collectionView.contentOffset.y + collectionView.contentInset.top)
            currentPage = Int(round(contentOffset / pageWidth))
        }
        if currentPage != self.currentPage {
            self.currentPage = currentPage
            self.delegate?.onCurrentPageChanged(layout: self, currentPage: currentPage)
        }
    }
    
}

public class CollectionViewStackLayout: UICollectionViewLayout {
    
    var numberOfVisibleCells: Int = 3
    
    // нельзя просто так взять и сказать, что размер контента == размеру коллекции - тогда коллекция не увидит смысла создавать больше 2-х ячеек (одна на экране, одна может быть появится)
    public override var collectionViewContentSize: CGSize {
        return self.collectionView?.bounds.size ?? .zero
    }
    
    // to override
    public func cellSizeFor(_ index: Int) -> CGRect {
        guard let collection = self.collectionView else {
            return .zero
        }

        let sideOffset: CGFloat = 16
        let bottomMargin: CGFloat = 16
        let topOffset: CGFloat = 40
        // рассчет для дизайна, когда нижние ячейки смещаются вниз
        /**         
         +------------+
         |            |
         |            |
         |            |
         +------------+
          +----------+
           +--------+
         */
        let x = sideOffset * CGFloat(index)
        let w = collection.bounds.width - 2 * x
        let y = topOffset * CGFloat(index)
        let h = collection.bounds.height - y - bottomMargin * CGFloat(numberOfVisibleCells - index)
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collection = self.collectionView,
            collection.numberOfSections > 0 else { return nil }
        // кроме того надо ограничить количеством видимых ячеек
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.zIndex = -indexPath.item
        attrs.frame = self.cellSizeFor(indexPath.item)
        attrs.isHidden = !(indexPath.item < numberOfVisibleCells)
        return attrs
    }
    
//  я никогда толком не пойму логики - когда какие методы перегружать; вот сейчас без этого можно обойтись; но - может быть (даже скорее всего, инфа сотка) просто потому, что у нас скроллер не задействован; если бы был скролл - то вызывался бы при каждом инвалидейте именно этот метод
//    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//
//        guard let collection = self.collectionView,
//            collection.numberOfSections > 0 else { return nil }
//
//        let nums = min(numberOfVisibleCells, collection.numberOfItems(inSection: 0))
//        return (0..<nums).map { (index) -> UICollectionViewLayoutAttributes in
//            let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
//
//            attrs.zIndex = -index
//
//
//            attrs.frame = self.cellSizeFor(index)
//            return attrs
//        }
//    }
}
