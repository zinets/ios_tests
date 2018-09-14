//
//  ProfilePhotoScrollerDatasource.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import CollectionControls

class ProfilePhotoScrollerDatasource: CollectionSectionDatasource {
    override var supportedCellTypes: [CellType] {
        return ["ProfileTopPhotoItem"]
    }
    
    override func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case "ProfileTopPhotoItem": // ячейка для фото использует xib с таким именем
            return "ProfilePhotoCell"
        default:
            return super.cellNibFor(cellType)
        }
    }
}

