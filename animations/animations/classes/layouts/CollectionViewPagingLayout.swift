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

public class CollectionViewProgressiveLayout: UICollectionViewLayout {
    
    public override class var layoutAttributesClass: AnyClass {
        return CollectionViewProgressLayoutAttributes.self
    }
    
    // MARK: properties -
    weak var delegate: CollectionViewProgressiveLayoutDelegate?
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
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
    
    private var visibleRect: CGRect {
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
        return (0..<numberOfItems).map { (item) -> CollectionViewProgressLayoutAttributes in
            let attrs = CollectionViewProgressLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            let progress = CGFloat(item) - (self.scrollDirection == .horizontal ? visibleRect.minX / visibleRect.width : visibleRect.minY / visibleRect.height)
            attrs.frame = visibleRect
            attrs.progress = progress
            attrs.zIndex = Int(-abs(round(progress)))
            attrs.isHidden = abs(progress) > 1 // TODO: и/или если индекс карточки > видимого кол-ва карточек
            
            return attrs
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
