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
    
    // исключение для ячеек, которые описываются в сториборде; т.е. если ячейка в сториборде - не вертаем имя ниб-а, ячейка уже зарегистрирована
    static func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case .ProfileButtonsItem, .ProfileAboutInfoItem, .ProfileAboutSubtitleItem,
             .ProfileAboutDescriptionItem, .ProfileAboutItem:
            return nil
        
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
