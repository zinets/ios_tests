//
//  PhotoScrollerDatasource.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class PhotoScrollerDatasource: CollectionSectionDatasource {
    
    override var supportedCellTypes: [CellType] {
        return [.TestPhotoItem]
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
