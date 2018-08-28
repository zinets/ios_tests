//
//  PhotosDatasource.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class MediaScrollerDatasource : CollectionSectionDatasource {
    
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
        if items[indexPath.item] is PhotoFromInternetModel {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCellId, for: indexPath) as? PhotoFromInternetCell {
                cell.data = items[indexPath.item] as? PhotoFromInternetModel
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            return UICollectionViewCell()
        }
    }
}
