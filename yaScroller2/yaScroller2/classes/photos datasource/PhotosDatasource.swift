//
//  PhotosDatasource.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class PhotosDatasource : CollectionSectionDatasource {
    
    let sectionCellId = "PhotoFromInternetCell"
    
    // MARK: overrides -
    
    override var collectionView: UICollectionView? {
        didSet {
            if let collection = collectionView {
                collection.register(UINib(nibName: sectionCellId, bundle: nil), forCellWithReuseIdentifier: sectionCellId)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
