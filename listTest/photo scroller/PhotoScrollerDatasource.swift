//
//  PhotoScrollerDatasource.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class PhotoScrollerDatasource: CollectionSectionDatasource {
    
    let supportedCells: [CellType] = [.TestPhotoItem]
    
    override var collectionView: UICollectionView? {
        didSet {
            if let collection = collectionView {
                for cellType in supportedCells {
                    let cellId = CellsFactory.cellIdFor(cellType)
//                    let cellClass = CellsFactory.cellClassFor(cellType)
                    let cellNib = CellsFactory.cellNibFor(cellType)
                    
                    collection.register(UINib(nibName: cellNib, bundle: nil), forCellWithReuseIdentifier: cellId)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = CellsFactory.cellIdFor(.TestPhotoItem) // всегда 1 тип ячейки
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoCell {
            cell.fillData(items[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}
