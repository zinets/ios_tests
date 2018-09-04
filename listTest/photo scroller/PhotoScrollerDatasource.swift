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
}
