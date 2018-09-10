//
//  ProfileDatasource.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class ProfileDatasource: TableSectionDatasource {
    
    override var supportedCellTypes: [CellType] {
        return ["ProfileButtonsItem",
                "ProfileAboutInfoItem",
                "ProfileAboutSubtitleItem",
                "ProfileAboutDescriptionItem",
                "ProfileAboutItem"]
    }
    

    // этот метод не реализован, т.к. диз всех ячеек в сториборде
//    open func cellNibFor(_ cellType: CellType) -> String?
    // этот метод не реализован, т.к. reuseCellId совпадает с типом ячейки, а это реализуется в базовом классе
//    open func cellIdFor(_ cellType: CellType) -> String
}
