//
//  MediaScrollerView.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

/*  класс для скрола всяких картинок; требует класс-датасорс (MediaScrollerDatasource) для прозрачной вставки/удаления элементов
 данные для показа передаются в items и внутри передается в внутренний датасорс
 регистрация ячейки производится в MediaScrollerDatasource; вообще тот класс должен понимать, что делать с данными, которые ему передаются через items -
 */

class MediaScrollerView: UIView, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    var autoScrollInterval: TimeInterval = 4
    private var scrollTimer: Timer?
    private var tapRecognizer: UITapGestureRecognizer?
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        internalDatasource.collectionView = collectionView
        internalDatasource.onItemChanged = {
            if let ctrl = self.pageControl {
                ctrl.numberOfPages = self.internalDatasource.items.count
            }
        }
        scrollDirection = .horizontal
        addSubview(collectionView)
        
        contentMode = .scaleAspectFill
    }
    
    // MARK: overrides -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: collection -
    
    private lazy var internalDatasource = MediaScrollerDatasource()
    
    private lazy var collectionView: UICollectionView = {
        var layout = MediaScrollerViewLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        var _collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        _collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        _collectionView.backgroundColor = UIColor.white
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        _collectionView.delegate = self
        
        
        return _collectionView
    }()
    
    // MARK: scrolling -
    
    /// выравнивать ли ячейки
    var paginating = true
    /// ограничить прокрутку одним элементов за раз
    var oneElementPaginating = true
    /// бесконечная прокрутка
    var endlessScrolling = false
    /// направление прокрутки
    var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = scrollDirection
                layout.invalidateLayout()
            }
        }
    }
    /// автоскролл
    var autoScroll = false {
        didSet {
            if autoScroll != oldValue {
                recreateScrollingTimer()
            }
        }
    }
    /// tap to scroll - тап по краю картинки (скажем, на расстоянии ХХ от края) вызывает прокрутку
    var tapToScrollArea: CGFloat = 50
    var tapToScroll = false {
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        destroyScrollTimer()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if paginating {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                var targetOffset = targetContentOffset.pointee
                let horizontalScrolling = scrollDirection == .horizontal
                let proposedOffset = horizontalScrolling ? targetOffset.x : targetOffset.y
                let pageWidth = horizontalScrolling ? (layout.itemSize.width + layout.minimumInteritemSpacing) : (layout.itemSize.height + layout.minimumLineSpacing)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalScrolling = scrollDirection == .horizontal
            let pageWidth = horizontalScrolling ? (layout.itemSize.width + layout.minimumInteritemSpacing) : (layout.itemSize.height + layout.minimumLineSpacing)
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
    
    // MARK: animated bounds changing -
    
    override var contentMode: UIViewContentMode {
        didSet {
            if let layout = collectionView.collectionViewLayout as? MediaScrollerViewLayout {
                layout.contentMode = contentMode
            }
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
    
    var items: [AnyHashable] {
        get {
            return internalDatasource.items
        }
        set {
            internalDatasource.items = newValue
            recreateScrollingTimer()
        }
    }
    
    var itemIndex: Int? {
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
    @IBOutlet weak var pageControl: PageControlProto!
}
