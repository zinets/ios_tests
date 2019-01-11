//
//  TapplInfiniteOnboardingScroller.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 1/9/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

/// 15 (?) фоточек/картинок, отобранных дизайнерами, скролятся вертикально бесконечно; таких скроллеров будет несколько, из них образуется контрол с встречно ползущими полосами из фоток

class TapplAnimatedOnboardingBgView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private var site: UIView?
    private func commonInit() {
        if site != nil {
            site!.removeFromSuperview()
        }
        
        let angle: CGFloat = 50 // по дизу наклон движущихся полос
        let rad = angle * .pi / 180.0
        let size = self.bounds.size
        let W = size.width
        let H = size.height
        
        let cosA = cos(rad)
        let sinA = sin(rad)
        
        let h = H * cosA + W * sinA
        let w = H * sinA + W * cosA
        
        site = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        site!.backgroundColor = .red
        site!.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        site!.transform = CGAffineTransform(rotationAngle: rad)
        self.addSubview(site!)
        
        self.clipsToBounds = true
        
        var x: CGFloat = -30
        var direction = false
        while x < w {
            let frame = CGRect(x: x, y: 0, width: TapplInfiniteOnboardingScroller.cellSize.width, height: h)
            let scroller = TapplInfiniteOnboardingScroller(frame: frame)
            site!.addSubview(scroller)
                        
            x += TapplInfiniteOnboardingScroller.cellSize.width + TapplInfiniteOnboardingScroller.cellSpacing
            direction = !direction
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        commonInit()
//    }
//
    private var timer: Timer?
    func startAnimation() {
        guard timer == nil else {
            return
        }
        
        for view in self.site!.subviews {
            if let scroller = view as? TapplInfiniteOnboardingScroller {
                let collectionView = scroller.collectionView
                var pt = collectionView.contentOffset
                pt.y = CGFloat.random(in: 0..<TapplInfiniteOnboardingScroller.cellSize.height)
                collectionView.contentOffset = pt
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1 / Double(stepsCount), target: self, selector: #selector(scrollCollection), userInfo: nil, repeats: true)
    }
    
    func stopAnimation() {
        if let _ = timer {
            timer!.invalidate()
            timer = nil
        }
    }
    
    private let stepsCount = 30
    private let stepInPix: CGFloat = 0.2
    @objc private func scrollCollection() {
        var direction = false
        for view in self.site!.subviews {
            if let scroller = view as? TapplInfiniteOnboardingScroller {
                let collectionView = scroller.collectionView
                var pt = collectionView.contentOffset
                pt.y += (direction ? 1 : -1) * stepInPix
                collectionView.contentOffset = pt
            }
            direction = !direction
        }
//        var pt = self.collectionView.contentOffset
//        pt.y = self.reverseDirection ? (pt.y - stepInPix) : (pt.y + stepInPix)
//        self.collectionView.contentOffset = pt
    }
}

private class FaceGenerator {
    private static let maxCount = 22
    private static var currentIndex: Int = 0
    private static var data: [String] = {
        var temp: [String] = []
        var data: [String] = []
        
        for i in 1...maxCount {
            temp.append(String(format: "%02d", i))
        }
        
        while temp.count > 0 {
            let randomIndex = Int.random(in: 0..<temp.count)
            data.append(temp[randomIndex])
            temp.remove(at: randomIndex)
        }
        return data
    }()
    
    static func getFace() -> String {
        let fn = data[currentIndex]
        currentIndex += 1
        if currentIndex >= maxCount {
            currentIndex = 0
        }
        return fn
    }
}

class TapplInfiniteOnboardingScroller: UIView {
    
    private static let cellsCount = 5
    private static let cellId = "InfiniteCellID"
    static let cellSpacing: CGFloat = 8
    static let cellSize = CGSize(width: 98, height: 148)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    fileprivate var dataSource: [String] = []
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = TapplInfiniteOnboardingScroller.cellSpacing
        layout.minimumInteritemSpacing = TapplInfiniteOnboardingScroller.cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        for i in 1...TapplInfiniteOnboardingScroller.cellsCount {
            dataSource.append(FaceGenerator.getFace())
        }
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(TapplInfiniteOnboardingScrollerCell.self, forCellWithReuseIdentifier: TapplInfiniteOnboardingScroller.cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private func commonSetup() {
        self.addSubview(self.collectionView)
        
//        self.startAnimation()
    }
    


}

extension TapplInfiniteOnboardingScroller: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TapplInfiniteOnboardingScroller.cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapplInfiniteOnboardingScroller.cellId, for: indexPath)
        return cell
    }
    
}

extension TapplInfiniteOnboardingScroller: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let infiniteCell = cell as? TapplInfiniteOnboardingScrollerCell {
            let fn = dataSource[indexPath.item]
            infiniteCell.image = UIImage(named: fn)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            collectionView.contentSize.height > 0
            else { return }
        
        let minOffset: CGFloat = 0
        let maxOffset = scrollView.contentSize.height - scrollView.bounds.size.height
        var pt = scrollView.contentOffset
        let currentOffset = pt.y
        if currentOffset < minOffset {
            let obj = dataSource.removeLast()
            dataSource.insert(obj, at: 0)
            pt.y += TapplInfiniteOnboardingScroller.cellSize.height + TapplInfiniteOnboardingScroller.cellSpacing
            self.collectionView.contentOffset = pt
            
            UIView.setAnimationsEnabled(false)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [IndexPath(item: dataSource.count - 1, section: 0)])
                collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            }) { (_) in
                UIView.setAnimationsEnabled(true)
            }
        } else if currentOffset > maxOffset {
            let obj = dataSource.removeFirst()
            dataSource.append(obj)
            pt.y -= TapplInfiniteOnboardingScroller.cellSize.height + TapplInfiniteOnboardingScroller.cellSpacing
            self.collectionView.contentOffset = pt
            
            UIView.setAnimationsEnabled(false)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
                collectionView.insertItems(at: [IndexPath(item: dataSource.count - 1, section: 0)])
            }) { (_) in
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return TapplInfiniteOnboardingScroller.cellSize
    }
}

class TapplInfiniteOnboardingScrollerCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    private var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        
        self.contentView.addSubview(imageView)
    }
}
