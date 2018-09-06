//
//  InstagramPageControl.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/6/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

protocol IPageControlDatasource {
    func pageControl(_ sender: IPageControl, viewForIndex: Int) -> IPageControlItem
}

class IPageControl: UIView {
    
    var dataSource: IPageControlDatasource?
    
    private var scrollerView: UIScrollView = {
        let scroller = UIScrollView()
        scroller.backgroundColor = UIColor.clear
        scroller.isUserInteractionEnabled = false
        scroller.showsVerticalScrollIndicator = false
        return scroller
    }()
    private var canScroll = true
    private var items = [IPageControlItem]()

    var hidesForSinglePage = false {
        didSet {
            scrollerView.isHidden = numberOfPages <= 1 && hidesForSinglePage
        }
    }
    var displayCount: Int = 7 {
        didSet {
            canScroll = numberOfPages > displayCount
            update()
        }
    }
    var animateDuration: TimeInterval = 0.75
    var numberOfPages: Int = 0 {
        didSet {
            scrollerView.isHidden = numberOfPages <= 1 && hidesForSinglePage
            displayCount = min(displayCount, numberOfPages)
        }
    }
    var currentPage: Int = 0 {
        didSet {
            if (currentPage != oldValue && currentPage >= 0 && currentPage < numberOfPages) {
                scrollerView.layer.removeAllAnimations()
                setCurrentPage(currentPage, animated: true)
            } else {
                currentPage = oldValue
            }
        }
    }
    var dotSize: CGFloat = 8 {
        didSet {
            update()
        }
    }
    var dotSpace: CGFloat = 8 {
        didSet {
            update()
        }
    }
    
    private func commonInit() {
        hidesForSinglePage = true
        
        numberOfPages = 0
        currentPage = 0
        displayCount = 7
        
        dotSize = 8
        dotSpace = 8
        
        scrollerView.frame = bounds
        addSubview(scrollerView)
        updateViewSize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func updateViewSize() {
        var b = self.bounds
        b.size = self.intrinsicContentSize
        self.bounds = b
    }
    
    private var itemSize: CGFloat {
        return dotSize + dotSpace
    }
    
    private func setCurrentPage(_ page: Int, animated: Bool) {
        if canScroll {
            updateDotPosition(page, animated: animated)
        }
        updateDotSize(page, animated: animated)
    }
    
    private func updateDotPosition(_ position: Int, animated: Bool) {
        let duration = animated ? animateDuration : 0
        if currentPage == 0 {
            moveScrollView(-scrollerView.contentInset.left, duration: duration)
        } else if currentPage == numberOfPages - 1 {
            moveScrollView(scrollerView.contentSize.width - scrollerView.bounds.size.width + scrollerView.contentInset.right, duration: duration)
        } else if CGFloat(currentPage) * itemSize <= scrollerView.contentOffset.x + itemSize {
            moveScrollView(scrollerView.contentOffset.x - itemSize, duration: duration)
        } else if CGFloat(currentPage) * itemSize + itemSize >= scrollerView.contentOffset.x + scrollerView.bounds.size.width - itemSize {
            moveScrollView(scrollerView.contentOffset.x + itemSize, duration: duration)
        }
    }
    
    private func updateDotSize(_ position: Int, animated: Bool) {
        let duration = animated ? animateDuration : 0
        for item in items {
            item.animationDuration = duration
            
            if item.index == currentPage {
                item.state = .active
            } else if !canScroll {
                item.state = .normal
            } else if item.index < 0 {
                item.state = .none
            } else if item.index > numberOfPages - 1 {
                item.state = .none
            } else if item.frame.maxX <= scrollerView.contentOffset.x {
                item.state = .none
            } else if item.frame.minX >= scrollerView.contentOffset.x + scrollerView.bounds.size.width {
                item.state = .none
            } else if item.frame.minX <= scrollerView.contentOffset.x {
                item.state = .small
            } else if item.frame.maxX >= scrollerView.contentOffset.x + scrollerView.bounds.size.width {
                item.state = .small
            } else if item.frame.minX <= scrollerView.contentOffset.x + self.itemSize {
                item.state = .medium
            } else if item.frame.maxX >= scrollerView.contentOffset.x + scrollerView.bounds.size.width - self.itemSize {
                item.state = .medium
            } else {
                item.state = .normal
            }
        }
    }
    
    private func update() {
        if let ds = dataSource {
            var arr = [IPageControlItem]()
            for index in -2..<numberOfPages + 2 {
                let itemView = ds.pageControl(self, viewForIndex: index)
                arr.append(itemView)
            }
            items = arr
            
            for view in scrollerView.subviews {
                view.removeFromSuperview()
            }
            scrollerView.contentSize = CGSize(width: itemSize * CGFloat(numberOfPages), height: dotSize)
            for index in 0..<items.count {
                scrollerView.addSubview(items[index])
            }
            
            let size = CGSize(width: itemSize * CGFloat(displayCount), height: dotSize)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            scrollerView.frame = frame
            
            if displayCount < numberOfPages {
                scrollerView.contentInset = UIEdgeInsets(top: 0, left: itemSize * 2, bottom: 0, right: itemSize * 2)
            } else {
                scrollerView.contentInset = UIEdgeInsets.zero
            }
        }
    }
    
    private func moveScrollView(_ x: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            var pt = self.scrollerView.contentOffset
            pt.x = x
            self.scrollerView.contentOffset = pt
        }
    }
    
    // MARK: overrides -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollerView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.itemSize * CGFloat(self.displayCount), height: self.itemSize)
    }
}
