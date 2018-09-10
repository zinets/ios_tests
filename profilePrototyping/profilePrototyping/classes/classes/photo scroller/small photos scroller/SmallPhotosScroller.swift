//
//  SmallPhotosScroller.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

/// конкретный скроллер конкретных вещей - фотографий юзера
class SmallPhotosScroller: CollectionBasedScrollerView {
    override open func datasourceForCollection() -> CollectionSectionDatasource {
        return SmallPhotosDatasource()
    }
    
    override open func layoutForCollection() -> UICollectionViewLayout {
        let layout = super.layoutForCollection()
        
//        layout.itemSize = CGSize(width: 100, height: 100)
        
        return layout
    }
}

private class SmallPhotosDatasource: CollectionSectionDatasource {
    
    override var supportedCellTypes: [CellType] {
        return ["PortraitProfilePhotoItem"]
    }
    
    override func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case "PortraitProfilePhotoItem":
            return "SmallPhotoScrollerCell"
        default:
            return super.cellNibFor(cellType)
        }
    }
}
