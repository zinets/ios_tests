//
//  CellTypes.swift
//

import Foundation

// т.к. тип от String, то rawValue == написанию энума и это будет использовано для регистрации ячеек
enum CellType: String {
    // Profile
    case ProfileTopPhotoItem        // фото в листалке (большой) фото профиля
    case ProfileOwnPhotoItem        // верхнее фото в своем профиле
    case ProfileButtonsItem         // первый блок в чужом профиле, скошенный + кнопки
    case ProfileAboutInfoItem       // блок скриннейм+возраст+локация
    case ProfileAboutSubtitleItem   // подзаголовки about, personality etc
    case ProfileAboutDescriptionItem // блок с текстом "обамне"
    case ProfileAboutItem           // значение из about - height, marital status
    case ProfilePhotosListItem      // блок в конце профиля, если фото > 1
}

// ячейка должна уметь показать переданные ей данные
protocol DataAwareCell {
    func fillWithData(_ data: DataSourceItem)
}
