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
        case .ProfileTopPhotoItem: // ячейка для фото использует xib с таким именем
            return "ProfilePhotoCell"
        default:
            return cellType.rawValue
        }
    }
    
    static func cellIdFor(_ cellType: CellType) -> String {
        switch cellType {
        //            case .ProfileTopPhotoItem: // в xib указан cellReuseId такой же, как и тип ячейки - поэтому можно не указывать отдельно cellId; а если нужно то можно и указывать
        default:
            return cellType.rawValue
        }
    }
}
