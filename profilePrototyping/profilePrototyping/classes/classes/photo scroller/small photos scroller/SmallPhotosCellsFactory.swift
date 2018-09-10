//
//  SmallPhotosCellsFactory.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class SmallPhotosCellsFactory: CellsFactory {

    override func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case "ProfilePhotosListItem": 
            return "SmallPhotoScrollerCell"
        default:
            return super.cellNibFor(cellType)
        }
    }
}
