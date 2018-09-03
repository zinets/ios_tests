//
//  IntroView.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class IntroView: UIView, UICollectionViewDelegateFlowLayout {

    var dataSource: CollectionSectionDatasource? {
        didSet {
            dataSource?.collectionView = self.collectionView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(collectionView)
        
        
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        layout.itemSize = bounds.size
        
        var _collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        _collectionView.backgroundColor = backgroundColor
        _collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        _collectionView.isPagingEnabled = true
        _collectionView.delegate = self
        
        return _collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
