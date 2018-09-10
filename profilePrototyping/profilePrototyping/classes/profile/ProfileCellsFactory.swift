//
//  ProfileCellsFactory.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileCellsFactory: CellsFactory {
     override func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case "ProfileButtonsItem",
             "ProfileAboutInfoItem",
             "ProfileAboutSubtitleItem",
             "ProfileAboutDescriptionItem",
             "ProfileAboutItem":
            return nil              // ячейки используют дизайн из сториборда - указывать xib не нужно
        default:
            return super.cellNibFor(cellType)
        }
    }
    
    override func cellIdFor(_ cellType: CellType) -> String {
        switch cellType {
        default:
            return cellType
        }
    }
}
