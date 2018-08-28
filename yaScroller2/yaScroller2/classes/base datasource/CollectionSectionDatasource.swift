//
//  CollectionSectionDatasource.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class CollectionSectionDatasource : SectionDatasource, UICollectionViewDataSource {
    var section: Int = 0
    var collectionView: UICollectionView? {
        didSet {
            if let collection = collectionView {
                collection.dataSource = self
            }
        }
    }
    
    // MARK: overrides -
    
    override var items:[AnyHashable] {
        get {
            return super.items
        }
        set (newItems) {
            super.items = newItems
            
            if let collection = collectionView {
                collection.performBatchUpdates({
                    if (toRemove.count > 0) {
                        var array = [IndexPath]()
                        for index in toRemove {
                            array.append(IndexPath(item: index, section: section))
                        }
                        collection.deleteItems(at: array)
                    }
                    if (!toInsert.isEmpty) {
                        var array = [IndexPath]()
                        for index in toInsert {
                            array.append(IndexPath(item: index, section: section))
                        }
                        collection.insertItems(at: array)
                    }
                    if (!toUpdate.isEmpty) {
                        var array = [IndexPath]()
                        for item in toUpdate {
                            array.append(IndexPath(item: item, section: section))
                        }
                        collection.reloadItems(at: array)
                    }
                }) { (finished) in
                    
                }
            }
        }
    }
    
    // MARK: collection support -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
