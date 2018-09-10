//
//  CellsFactory.swift
//

import UIKit

// ячейка должна уметь показать переданные ей данные
protocol DataAwareCell {
    func fillWithData(_ data: DataSourceItem)
}

class CellsFactory {
    
    // для регистрации кодом
//    static func cellClassFor(_ cellType: CellType) -> AnyClass {
//    }
    
    // исключение для ячеек, которые описываются в сториборде; т.е. если ячейка в сториборде - не вертаем имя ниб-а, ячейка уже зарегистрирована
    static func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case "ProfileButtonsItem",
             "ProfileAboutInfoItem",
             "ProfileAboutSubtitleItem",
             "ProfileAboutDescriptionItem",
             "ProfileAboutItem":
            return nil
        case "ProfileTopPhotoItem": // ячейка для фото использует xib с таким именем
            return "ProfilePhotoCell"
        case "ProfilePhotosListItem":
            return "SmallPhotoScrollerCell"
        default:
            return cellType
        }
    }
    
    static func cellIdFor(_ cellType: CellType) -> String {
        switch cellType {
        //            case .ProfileTopPhotoItem: // в xib указан cellReuseId такой же, как и тип ячейки - поэтому можно не указывать отдельно cellId; а если нужно то можно и указывать
        default:
            return cellType
        }
    }
}
