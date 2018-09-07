//
//  IPageControl.swift
//

import UIKit

protocol IPageControlDatasource {
    func pageControl(_ sender: IPageControl, viewForIndex: Int) -> IPageControlItem
}

class IPageControl: UIView, PageControlProto {
    
    // MARK: public
    
    public struct Config {
        
        public var displayCount: Int
        public var dotSize: CGFloat
        public var dotSpace: CGFloat
        public var smallDotSizeRatio: CGFloat
        public var mediumDotSizeRatio: CGFloat
        
        public init(displayCount: Int = 7,
                    dotSize: CGFloat = 6.0,
                    dotSpace: CGFloat = 4.0,
                    smallDotSizeRatio: CGFloat = 0.5,
                    mediumDotSizeRatio: CGFloat = 0.7) {
            self.displayCount = displayCount
            self.dotSize = dotSize
            self.dotSpace = dotSpace
            self.smallDotSizeRatio = smallDotSizeRatio
            self.mediumDotSizeRatio = mediumDotSizeRatio
        }
    }
    
    // default config
    
    private var config = Config()
    
    public func setConfig(_ config: Config) {
        
        self.config = config
        
        update(currentPage: currentPage, config: config)
    }
    
    public func setCurrentPage(at currentPage: Int, animated: Bool = false) {
        
        guard (currentPage < numberOfPages && currentPage >= 0) else { return }
        guard currentPage != self.currentPage else { return }
        
        scrollView.layer.removeAllAnimations()
        //        update(currentPage: currentPage, config: config)
        updateDot(at: currentPage, animated: animated)
        self.currentPage = currentPage
    }
    
    public private(set) var currentPage: Int = 0
    
    public var pageIndex: Int {
        set {
            setCurrentPage(at: newValue, animated: true)
        }
        get {
            return currentPage
        }
    }
    public var numberOfPages: Int = 0 {
        didSet {
            scrollView.isHidden = (numberOfPages <= 1 && hidesForSinglePage)
            config.displayCount = min(config.displayCount, numberOfPages)
            update(currentPage: currentPage, config: config)
        }
    }
    
    public var pageIndicatorTintColor: UIColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.00) {
        didSet {
            updateDotColor(currentPage: currentPage)
        }
    }
    
    public var currentPageIndicatorTintColor: UIColor = UIColor(red:0.32, green:0.59, blue:0.91, alpha:1.00) {
        didSet {
            updateDotColor(currentPage: currentPage)
        }
    }
    
    public var animateDuration: TimeInterval = 0.3
    
    public var hidesForSinglePage: Bool = false {
        didSet {
            scrollView.isHidden = (numberOfPages <= 1 && hidesForSinglePage)
        }
    }
    
    public init() {
        super.init(frame: .zero)
        
        setup()
        updateViewSize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        updateViewSize()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: itemSize * CGFloat(config.displayCount), height: itemSize)
    }
    
    public func setProgress(contentOffsetX: CGFloat, pageWidth: CGFloat) {
        let currentPage = Int(round(contentOffsetX / pageWidth))
        setCurrentPage(at: currentPage, animated: true)
    }
    
    public func updateViewSize() {
        self.bounds.size = intrinsicContentSize
    }
    
    // MARK: private
    private let scrollView = UIScrollView()
    
    private var itemSize: CGFloat {
        
        return config.dotSize + config.dotSpace
    }
    
    private var items: [IPageControlItem] = []
    
    private func setup() {
        backgroundColor = .clear
        
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        
        addSubview(scrollView)
    }
    
    private func update(currentPage: Int, config: Config) {
        
        if currentPage < config.displayCount {
            
            items = (-2..<(config.displayCount + 2))
                .map { IPageControlItem(itemSize: itemSize, dotSize: config.dotSize, index: $0) }
        }
        else {
            
            guard let firstItem = items.first else { return }
            guard let lastItem = items.last else { return }
            items = (firstItem.index...lastItem.index)
                .map { IPageControlItem(itemSize: itemSize, dotSize: config.dotSize, index: $0) }
        }
        
        scrollView.contentSize = .init(width: itemSize * CGFloat(numberOfPages), height: itemSize)
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        items.forEach { scrollView.addSubview($0) }
        
        let size: CGSize = .init(width: itemSize * CGFloat(config.displayCount), height: itemSize)
        let frame: CGRect = .init(origin: .zero, size: size)
        
        scrollView.frame = frame
        
        if config.displayCount < numberOfPages {
            scrollView.contentInset = .init(top: 0, left: itemSize * 2, bottom: 0, right: itemSize * 2)
        }
        else {
            scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        updateDot(at: currentPage, animated: false)
    }
    
    private func updateDot(at currentPage: Int, animated: Bool) {
        updateDotColor(currentPage: currentPage)
        
        if numberOfPages > config.displayCount {
            updateDotPosition(currentPage: currentPage, animated: animated)
            updateDotSize(currentPage: currentPage, animated: animated)
        }
    }
    
    private func updateDotColor(currentPage: Int) {
        items.forEach {
            $0.dotColor = ($0.index == currentPage) ?
                currentPageIndicatorTintColor : pageIndicatorTintColor
        }
    }
    
    private func updateDotPosition(currentPage: Int, animated: Bool) {
        
        let duration = animated ? animateDuration : 0
        
        if currentPage == 0 {
            let x = -scrollView.contentInset.left
            moveScrollViewView(x: x, duration: duration)
        }
        else if currentPage == numberOfPages - 1 {
            let x = scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right
            moveScrollViewView(x: x, duration: duration)
        }
        else if CGFloat(currentPage) * itemSize <= scrollView.contentOffset.x + itemSize {
            let x = scrollView.contentOffset.x - itemSize
            moveScrollViewView(x: x, duration: duration)
        }
        else if CGFloat(currentPage) * itemSize + itemSize >=
            scrollView.contentOffset.x + scrollView.bounds.width - itemSize {
            let x = scrollView.contentOffset.x + itemSize
            moveScrollViewView(x: x, duration: duration)
        }
    }
    
    private func updateDotSize(currentPage: Int, animated: Bool) {
        
        let duration = animated ? animateDuration : 0
        
        items.forEach { item in
            item.animateDuration = duration
            if item.index == currentPage {
                item.state = .normal
            }
                // outside of left
            else if item.index < 0 {
                item.state = .none
            }
                // outside of right
            else if item.index > numberOfPages - 1 {
                item.state = .none
            }
                // first dot from left
            else if item.frame.minX <= scrollView.contentOffset.x {
                item.state = .small
            }
                // first dot from right
            else if item.frame.maxX >= scrollView.contentOffset.x + scrollView.bounds.width {
                item.state = .small
            }
                // second dot from left
            else if item.frame.minX <= scrollView.contentOffset.x + itemSize {
                item.state = .medium
            }
                // second dot from right
            else if item.frame.maxX >= scrollView.contentOffset.x + scrollView.bounds.width - itemSize {
                item.state = .medium
            }
            else {
                item.state = .normal
            }
//            print(item.state)
        }
    }
    
    private func moveScrollViewView(x: CGFloat, duration: TimeInterval) {
        
        let direction = behaviorDirection(x: x)
        reusedView(direction: direction)
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            self.scrollView.contentOffset.x = x
        })
    }
    
    private enum Direction {        
        case left, right, stay
    }
    
    private func behaviorDirection(x: CGFloat) -> Direction {
        
        switch x {
        case let x where x > scrollView.contentOffset.x:
            return .right
        case let x where x < scrollView.contentOffset.x:
            return .left
        default:
            return .stay
        }
    }
    
    private func reusedView(direction: Direction) {
        
        guard let firstItem = items.first else { return }
        guard let lastItem = items.last else { return }
        
        switch direction {
        case .left:
            
            lastItem.index = firstItem.index - 1
            lastItem.frame = CGRect(x: CGFloat(lastItem.index) * itemSize, y: 0, width: itemSize, height: itemSize)
            items.insert(lastItem, at: 0)
            items.removeLast()
            
        case .right:
            
            firstItem.index = lastItem.index + 1
            firstItem.frame = CGRect(x: CGFloat(firstItem.index) * itemSize, y: 0, width: itemSize, height: itemSize)
            items.insert(firstItem, at: items.count)
            items.removeFirst()
            
        case .stay:
            
            break
        }
    }
}
