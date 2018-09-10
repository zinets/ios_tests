//
//  CellsFactory.swift
//

import UIKit

typealias CellType = String

// т.к. тип от String, то rawValue == написанию энума и это будет использовано для регистрации ячеек
//enum CellType: String {
//    // Profile
//    case ProfileTopPhotoItem        // фото в листалке (большой) фото профиля
//    case ProfileOwnPhotoItem        // верхнее фото в своем профиле
//    case ProfileButtonsItem         // первый блок в чужом профиле, скошенный + кнопки
//    case ProfileAboutInfoItem       // блок скриннейм+возраст+локация
//    case ProfileAboutSubtitleItem   // подзаголовки about, personality etc
//    case ProfileAboutDescriptionItem // блок с текстом "обамне"
//    case ProfileAboutItem           // значение из about - height, marital status
//    case ProfilePhotosListItem      // блок в конце профиля, если фото > 1
//}

// ячейка должна уметь показать переданные ей данные
protocol DataAwareCell {
    func fillWithData(_ data: DataSourceItem)
}

class CellsFactory {
    // для регистрации кодом возвращаем класс для ячейки указанного типа
    //  func cellClassFor(_ cellType: CellType) -> AnyClass {}
    
    // для регистрации xib-ом возвращаем имя файла с дизайном
    // исключение для ячеек, которые описываются в сториборде; т.е. если ячейка в сториборде - не вертаем имя ниб-а, ячейка уже зарегистрирована
    //    // поэтому редультат опциональный
    func cellNibFor(_ cellType: CellType) -> String? {
        return nil
    }
    
    // вовзращаем reuseCellId для ячейки указанного типа
    func cellIdFor(_ cellType: CellType) -> String {
        return cellType
    }
}
