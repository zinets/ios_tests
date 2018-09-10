//
//  ProfilePhotosCellsFactory.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfilePhotosCellsFactory: CellsFactory {

    override func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case "ProfileTopPhotoItem": // ячейка для фото использует xib с таким именем
            return "ProfilePhotoCell"
        default:
            return super.cellNibFor(cellType)
        }
    }
}
