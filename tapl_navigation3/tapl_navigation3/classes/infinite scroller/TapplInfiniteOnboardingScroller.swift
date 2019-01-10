//
//  TapplInfiniteOnboardingScroller.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 1/9/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class TapplInfiniteOnboardingScroller: UIView {
    
    static let cellsCount = 15
    static let cellId = "InfiniteCellID"

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
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        for i in 1...TapplInfiniteOnboardingScroller.cellsCount {
            dataSource.append(i.format(f: "02"))
        }
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(TapplInfiniteOnboardingScrollerCell.self, forCellWithReuseIdentifier: TapplInfiniteOnboardingScroller.cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        
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

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension TapplInfiniteOnboardingScroller: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let infiniteCell = cell as? TapplInfiniteOnboardingScrollerCell {
            let fn = dataSource[indexPath.item]
            infiniteCell.image = UIImage(named: fn)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 98, height: 148)
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
