//
//  CollectionBasedScrollerView.swift
//

import UIKit
import PageControls

// база для скроления чего-нибудь, использующего коллекцию; сама по себе работать не должна: нужно создать свой датасорс (который определяет ячейки, которые используются для коллекции; и который заполняет ячейки данными, но там все автоматизировано уже) и возвращать его в перегруженной функции datasourceForCollection
// если нужна спец.раскладка - нужно ее создать и вернуть в layoutForCollection

open class CollectionBasedScrollerView: UIView, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    // MARK: must be overrided -
    
    open func layoutForCollection() -> UICollectionViewLayout {
        // раскладка для скролера - простой горизонтальный скроллер с ячейкой на весь контрол
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        return layout
    }
    
    open func datasourceForCollection() -> CollectionSectionDatasource! {
        return nil
    }
    
    // MARK: properties -
    
    public var autoScrollInterval: TimeInterval = 4
    private var scrollTimer: Timer?
    private var tapRecognizer: UITapGestureRecognizer?
    
    // MARK: init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open func commonInit() {
        internalDatasource.collectionView = collectionView
        internalDatasource.onNumberOfItemsChanged = {
            if let ctrl = self.pageControl {
                ctrl.numberOfPages = self.internalDatasource.items.count
            }
        }
        scrollDirection = .horizontal
        addSubview(collectionView)        
    }
    
    // MARK: overrides -
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: collection -
    
    private lazy var internalDatasource = datasourceForCollection()!
    lazy public var collectionView: UICollectionView = {
        let layout = layoutForCollection()
        var _collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        _collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        _collectionView.backgroundColor = UIColor.white
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        _collectionView.delegate = self
        
        return _collectionView
    }()
    
    // MARK: scrolling -
    
    /// выравнивать ли ячейки
    public var paginating = false
    /// ограничить прокрутку одним элементов за раз
    public var oneElementPaginating = false
    /// бесконечная прокрутка
    public var endlessScrolling = false
    /// направление прокрутки
    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = scrollDirection
                layout.invalidateLayout()
            }
        }
    }
    /// автоскролл
    public var autoScroll = false {
        didSet {
            if autoScroll != oldValue {
                recreateScrollingTimer()
            }
        }
    }
    /// tap to scroll - тап по краю картинки (скажем, на расстоянии ХХ от края) вызывает прокрутку
    public var tapToScrollArea: CGFloat = 50
    public var tapToScroll = false {
        willSet {
            if newValue {
                if tapRecognizer == nil {
                    tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapRecognizer(_:)))
                    tapRecognizer?.delegate = self
                    self.addGestureRecognizer(tapRecognizer!)
                }
                
                tapRecognizer?.isEnabled = true
            } else {
                tapRecognizer?.isEnabled = false
            }
        }
    }
    
    @objc func onTapRecognizer(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: collectionView)
        var offset = collectionView.contentOffset
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            var pageIndex: Int
            var pageWidth: CGFloat
            if scrollDirection == .horizontal {
                pageWidth = layout.itemSize.width + layout.minimumInteritemSpacing
                pageIndex = Int(offset.x / pageWidth)
                if pt.x < offset.x + tapToScrollArea {
                    if !endlessScrolling {
                        pageIndex = max(0, pageIndex - 1)
                    } else {
                        pageIndex -= 1
                    }
                    offset.x = CGFloat(pageIndex) * pageWidth
                    collectionView.setContentOffset(offset, animated: true)
                } else if pt.x > offset.x + collectionView.bounds.size.width - tapToScrollArea {
                    if !endlessScrolling {
                        pageIndex = min(pageIndex + 1, internalDatasource.items.count - 1)
                    } else {
                        pageIndex += 1
                    }
                    offset.x = CGFloat(pageIndex) * pageWidth
                    collectionView.setContentOffset(offset, animated: true)
                }
            } else {
                pageWidth = layout.itemSize.height + layout.minimumLineSpacing
                pageIndex = Int(offset.y / pageWidth)
                if pt.y < offset.y + tapToScrollArea {
                    if !endlessScrolling {
                        pageIndex = max(0, pageIndex - 1)
                    } else {
                        pageIndex -= 1
                    }
                    offset.y = CGFloat(pageIndex) * pageWidth
                    collectionView.setContentOffset(offset, animated: true)
                } else if pt.y > offset.y + collectionView.bounds.size.height - tapToScrollArea {
                    if !endlessScrolling {
                        pageIndex = min(pageIndex + 1, internalDatasource.items.count - 1)
                    } else {
                        pageIndex += 1
                    }
                    offset.y = CGFloat(pageIndex) * pageWidth
                    collectionView.setContentOffset(offset, animated: true)
                }
            }
            recreateScrollingTimer()
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var res = false
        
        guard tapToScroll && internalDatasource.items.count > 2 else {
            return res
        }
        
        let pt = touch.location(in: collectionView)
        let offset = collectionView.contentOffset
        
        if scrollDirection == .horizontal {
            res = (pt.x < offset.x + tapToScrollArea) ||
                (pt.x > offset.x + collectionView.bounds.size.width - tapToScrollArea)
        } else {
            res = (pt.y < offset.y + tapToScrollArea) ||
                (pt.y > offset.y + collectionView.bounds.size.height - tapToScrollArea)
        }
        
        return res
    }
    
    // MARK: scroller delegate -
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        destroyScrollTimer()
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if paginating {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                var targetOffset = targetContentOffset.pointee
                let horizontalScrolling = scrollDirection == .horizontal
                let proposedOffset = horizontalScrolling ? targetOffset.x : targetOffset.y
                let cellSize = self.collectionView(scrollView as! UICollectionView, layout: layout, sizeForItemAt:IndexPath(item: 0, section: 0))
                let pageWidth = horizontalScrolling ? cellSize.width + layout.minimumInteritemSpacing : cellSize.height + layout.minimumLineSpacing
                let vel = horizontalScrolling ? velocity.x : velocity.y
                let offset = horizontalScrolling ? scrollView.contentOffset.x : scrollView.contentOffset.y
                
                var pageIndex = Int((proposedOffset + pageWidth / 2) / pageWidth)
                if oneElementPaginating {
                    // можно так - используя тот факт, что для 1страничного перелистывания нужно знать только направление листания
                    let curIndex = Int(offset / pageWidth)
                    if vel > 0 {
                        pageIndex = curIndex + 1
                    } else if vel < 0 {
                        pageIndex = curIndex
                    }
                }
                let newOffset = pageWidth * CGFloat(pageIndex)
                if horizontalScrolling {
                    targetOffset.x = newOffset
                } else {
                    targetOffset.y = newOffset
                }
                targetContentOffset.pointee = targetOffset
            }
        }
        
        recreateScrollingTimer()
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if endlessScrolling && !scrollView.isDecelerating {
            let horizontalScrolling = scrollDirection == .horizontal
            let minValue: CGFloat = 0
            let maxValue = horizontalScrolling ? (scrollView.contentSize.width - scrollView.bounds.size.width) : (scrollView.contentSize.height - scrollView.bounds.size.height)
            let curOffset = horizontalScrolling ? scrollView.contentOffset.x : scrollView.contentOffset.y
            var pt = scrollView.contentOffset
            if curOffset < minValue {
                if horizontalScrolling {
                    pt.x += scrollView.bounds.size.width
                } else {
                    pt.y += scrollView.bounds.size.height
                }
                scrollView.contentOffset = pt
                internalDatasource.shiftDataNext()
            } else if curOffset > maxValue {
                if horizontalScrolling {
                    pt.x -= scrollView.bounds.size.width
                } else {
                    pt.y -= scrollView.bounds.size.height
                }
                scrollView.contentOffset = pt
                internalDatasource.shiftDataPrev()
            }
        }
        
        if let index = self.itemIndex, let pageControl = self.pageControl {
            pageControl.pageIndex = index
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if paginating, let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalScrolling = scrollDirection == .horizontal
            let cellSize = self.collectionView(scrollView as! UICollectionView, layout: layout, sizeForItemAt:IndexPath(item: 0, section: 0)) // держим в уме, что все ячейки одинаковые, так что можно ориентироваться на ячейку 0:0
            let pageWidth = horizontalScrolling ? cellSize.width + layout.minimumInteritemSpacing : cellSize.height + layout.minimumLineSpacing
            let offset = horizontalScrolling ? scrollView.contentOffset.x : scrollView.contentOffset.y
            let pageIndex = Int((offset + pageWidth / 2) / pageWidth)
            var pt = scrollView.contentOffset
            if horizontalScrolling {
                pt.x = CGFloat(pageIndex) * pageWidth
            } else {
                pt.y = CGFloat(pageIndex) * pageWidth
            }
            
            scrollView.setContentOffset(pt, animated: true)
        }
    }

    // MARK: timer -
    
    private func recreateScrollingTimer() {
        scrollTimer?.invalidate()
        if autoScroll && internalDatasource.items.count > 1 {
            scrollTimer = Timer.scheduledTimer(timeInterval: autoScrollInterval, target: self, selector: #selector(onAutoscrollTimerEvent), userInfo: nil, repeats: true)
        } else {
            scrollTimer = nil
        }
    }
    
    private func destroyScrollTimer() {
        scrollTimer?.invalidate()
        scrollTimer = nil
    }
    
    @objc func onAutoscrollTimerEvent() {
        if autoScroll {
            var offset = collectionView.contentOffset
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                var pageIndex: Int
                var pageWidth: CGFloat
                
                if scrollDirection == .horizontal {
                    pageWidth = layout.itemSize.width + layout.minimumInteritemSpacing
                    pageIndex = Int(offset.x / pageWidth)
                    if endlessScrolling {
                        pageIndex += 1
                    } else {
                        if pageIndex == internalDatasource.items.count - 1 {
                            pageIndex = 0
                        } else {
                            pageIndex = min(pageIndex + 1, internalDatasource.items.count - 1)
                        }
                    }
                    offset.x = CGFloat(pageIndex) * pageWidth
                } else {
                    pageWidth = layout.itemSize.height + layout.minimumInteritemSpacing
                    pageIndex = Int(offset.y / pageWidth)
                    if endlessScrolling {
                        pageIndex += 1
                    } else {
                        if pageIndex == internalDatasource.items.count - 1 {
                            pageIndex = 0
                        } else {
                            pageIndex = min(pageIndex + 1, internalDatasource.items.count - 1)
                        }
                    }
                    offset.y = CGFloat(pageIndex) * pageWidth
                }
                collectionView.setContentOffset(offset, animated: true)
            }
        }
    }
    
    // MARK: datasource -
    
    // в массив с данными передаем структуру из типа (фото-ячейка) и ссылки на картинку (локальное имя для начала)
    public var items: [DataSourceItem] {
        get {
            return internalDatasource.items
        }
        set {
            internalDatasource.items = newValue
            recreateScrollingTimer()
        }
    }
    
    public var itemIndex: Int? {
        get {
            if !endlessScrolling && internalDatasource.items.count > 1 {
                
                let size: CGFloat = scrollDirection == .horizontal ? collectionView.bounds.width : collectionView.bounds.height
                let offset: CGFloat = size / 2 + (scrollDirection == .horizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y)
                
                let index = Int(offset / size)
                
                return index
                
                
            } else {
                return nil
            }
        }
    }
    
    // MARK: page indication -
    @IBOutlet weak open var pageControl: PageControlProtocol!
}




