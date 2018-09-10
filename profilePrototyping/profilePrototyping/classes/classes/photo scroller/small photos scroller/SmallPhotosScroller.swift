//
//  SmallPhotosScroller.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

/// конкретный скроллер конкретных вещей - фотографий юзера
class SmallPhotosScroller: CollectionBasedScrollerView {
    override func datasourceForCollection() -> CollectionSectionDatasource {
        return SmallPhotosDatasource(SmallPhotosCellsFactory())
    }
    
    override func layoutForCollection() -> UICollectionViewLayout {
        let layout = super.layoutForCollection()
        
//        layout.itemSize = CGSize(width: 100, height: 100)
        
        return layout
    }
}

private class SmallPhotosDatasource: CollectionSectionDatasource {
    override var supportedCellTypes: [CellType] {
        return ["PortraitProfilePhotoItem"]
    }
}
