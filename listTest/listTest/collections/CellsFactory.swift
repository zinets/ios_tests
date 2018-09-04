//
//  CellsFactory.swift
//

import UIKit

class CellsFactory {
    
    // для регистрации кодом
//    static func cellClassFor(_ cellType: CellType) -> AnyClass {
//        switch cellType {
//        case .TestPhotoItem:
//            return IntroCellOther.self
//        }
//    }
    
    static func cellNibFor(_ cellType: CellType) -> String {
        switch cellType {
        default:
            return cellType.rawValue
        }
    }
    
    static func cellIdFor(_ cellType: CellType) -> String {
        switch cellType {
        default:
            return cellType.rawValue
        }
    }
}
