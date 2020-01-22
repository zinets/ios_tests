//
//  CollectionViewPagingLayout.swift
//

import UIKit

public protocol CollectionViewPagingLayoutDelegate: class {
    func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int)
}

class CollectionViewPagingLayoutAttributes: UICollectionViewLayoutAttributes {
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

public class CollectionViewPagingLayout: UICollectionViewLayout {
    
    public override class var layoutAttributesClass: AnyClass {
        return CollectionViewPagingLayoutAttributes.self
    }
    
    // MARK: properties -
    weak var delegate: CollectionViewPagingLayoutDelegate?
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            self.invalidateLayout()
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        let safeAreaLeftRight = (collectionView?.safeAreaInsets.left ?? 0) + (collectionView?.safeAreaInsets.right ?? 0)
        let safeAreaTopBottom = (collectionView?.safeAreaInsets.top ?? 0) + (collectionView?.safeAreaInsets.bottom ?? 0)
        
        if self.scrollDirection == .horizontal {
            return CGSize(width: CGFloat(numberOfItems) * visibleRect.width - safeAreaLeftRight, height: visibleRect.height - safeAreaTopBottom)
        } else {
            return CGSize(width: visibleRect.width - safeAreaLeftRight, height: CGFloat(numberOfItems) *  visibleRect.height - safeAreaTopBottom)
        }
    }
    
    private(set) var currentPage: Int
    
    private var visibleRect: CGRect {
        guard let collectionView = collectionView else {
            return .zero
        }
        return CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
    }
    
    private var numberOfItems: Int {
        collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    // MARK: overrides -
    public override init() {
        currentPage = 0
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        currentPage = 0
        super.init(coder: aDecoder)
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
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return (0..<numberOfItems).map { (item) -> CollectionViewPagingLayoutAttributes in
            let attrs = CollectionViewPagingLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            let progress = CGFloat(item) - (self.scrollDirection == .horizontal ? visibleRect.minX / visibleRect.width : visibleRect.minY / visibleRect.height)
            attrs.frame = visibleRect
            attrs.progress = progress
            attrs.zIndex = Int(-abs(round(progress)))
            attrs.isHidden = abs(progress) > 1
            
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
