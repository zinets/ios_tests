//
//  MediaScrollerView.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class MediaScrollerView: UIView, UICollectionViewDelegate {
    
    var autoScrollInterval: TimeInterval = 4
    var scrollTimer: Timer?
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    func commonInit() {
        internalDatasource.collectionView = collectionView
        addSubview(collectionView)
    }
    
    // MARK: overrides -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: collection -
    
    lazy var internalDatasource = MediaScrollerDatasource()
    
    lazy var collectionView: UICollectionView = {
        var layout = MediaScrollerViewLayout()
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = .zero
        
        var _collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        _collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        _collectionView.backgroundColor = UIColor.white
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.delegate = self
        
        return _collectionView
    }()
    
    // MARK: scrolling -
    
    // MARK: datasource -
    
    var items: [AnyHashable] {
        get {
            return internalDatasource.items
        }
        set {
            internalDatasource.items = newValue
            // todo: scrolltimer
        }
    }
    
}
