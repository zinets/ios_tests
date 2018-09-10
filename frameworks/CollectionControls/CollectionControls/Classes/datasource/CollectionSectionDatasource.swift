//
//  CollectionSectionDatasource.swift
//

import UIKit

open class CollectionSectionDatasource : SectionDatasource, UICollectionViewDataSource {
    var section: Int = 0
    public var collectionView: UICollectionView? {
        didSet {
            if let collection = collectionView {
                collection.dataSource = self
                
                for cellType in supportedCellTypes {
                    let cellId = self.cellIdFor(cellType)
                    if let cellNib = self.cellNibFor(cellType) {
                        collection.register(UINib(nibName: cellNib, bundle: nil), forCellWithReuseIdentifier: cellId)
                    }
                }
            }
        }
    }
    
    // MARK: overrides -
    
    override open var items:[DataSourceItem] {
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
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = items[indexPath.item]
        let cellId = cellIdFor(data.itemType)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? DataAwareCell {
            cell.fillWithData(data)            
            return cell as! UICollectionViewCell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    
}
