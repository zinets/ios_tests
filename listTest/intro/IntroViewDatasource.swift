//
//  IntroViewDatasource.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class IntroViewDatasource: CollectionSectionDatasource {
    
    let supportedCells: [CellType] = [.TestIntroFirst, .TestIntroOther]
    
    override var collectionView: UICollectionView? {
        didSet {
            if let collection = collectionView {
                for cellType in supportedCells {
                    let cellId = CellsFactory.cellIdFor(cellType)
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
        
        if indexPath.item == 0 {
            let cellId = CellsFactory.cellIdFor(.TestIntroFirst)
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? IntroCellFirst {
                return cell
            }
        } else {
            let cellId = CellsFactory.cellIdFor(.TestIntroOther)
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? IntroCellOther {
                cell.fillData(items[indexPath.item])
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}
