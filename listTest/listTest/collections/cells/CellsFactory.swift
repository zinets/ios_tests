//
//  CellsFactory.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class CellsFactory {
    
    // для регистрации кодом
    static func cellClassFor(_ cellType: CellType) -> AnyClass {
        switch cellType {
        case .TestPhotoItem:
            return PhotoCell.self
        }
    }
    static func cellNibFor(_ cellType: CellType) -> String {
        switch cellType {
        case .TestPhotoItem:
            return "PhotoCell"
        }
    }
    
    static func cellIdFor(_ cellType: CellType) -> String {
        switch cellType {
        case .TestPhotoItem:
            return cellType.rawValue
        }
    }
}
