//
//  TapplInfiniteOnboardingScroller.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 1/9/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

//extension Int {
//    func format(f: String) -> String {
//        return String(format: "%\(f)d", self)
//    }
//}

/// 15 фоточек/картинок, отобранных дизайнерами, скролятся вертикально бесконечно; таких скроллеров будет несколько, из них образуется контрол с встречно ползущими полосами из фоток
class TapplInfiniteOnboardingScroller: UIView {
    
    static let cellsCount = 6
    static let cellId = "InfiniteCellID"
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
    
    var dataSource: [String] = []
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = TapplInfiniteOnboardingScroller.cellSpacing
        layout.minimumInteritemSpacing = TapplInfiniteOnboardingScroller.cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        for i in 1...TapplInfiniteOnboardingScroller.cellsCount {
            dataSource.append(String(format: "%02d", i))
        }
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(TapplInfiniteOnboardingScrollerCell.self, forCellWithReuseIdentifier: TapplInfiniteOnboardingScroller.cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        collectionView.isScrollEnabled = false
        
        
        return collectionView
    }()
    
    private func commonSetup() {
        self.addSubview(self.collectionView)
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
