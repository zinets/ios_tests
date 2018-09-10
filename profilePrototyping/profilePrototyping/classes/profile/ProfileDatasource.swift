//
//  ProfileDatasource.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileDatasource: TableSectionDatasource {

    override var supportedCellTypes: [CellType] {
        return ["ProfileButtonsItem",
                "ProfileAboutInfoItem",
                "ProfileAboutSubtitleItem",
                "ProfileAboutDescriptionItem",
                "ProfileAboutItem"]
    }
    
}
