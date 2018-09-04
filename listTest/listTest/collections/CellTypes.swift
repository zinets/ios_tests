//
//  CellTypes.swift
//

import Foundation

// т.к. тип от String, то rawValue == написанию энума и это будет использовано для регистрации ячеек
enum CellType: String {
    // Profile
//    case ProfileAboutPhotosItem - хз, не уверен еще, как будет сделан верхний блок профиля
    case ProfileAboutButtonsItem    // первый блок в чужом профиле, скошенный + кнопки
    case ProfileAboutInfoItem       // блок скриннейм+возраст+локация
    case ProfileAboutSubtitleItem   // подзаголовки about, personality etc
    case ProfileAboutDescriptionItem // блок с текстом "обамне"
    case ProfileAboutItem           // значение из about - height, marital status
    case ProfileAboutPhotosItem     // блок в конце профиля, если фото > 1
}

// ячейка должна уметь показать переданные ей данные
protocol DataAwareCell {
    func fillWithData(_ data: DataSourceItem)
}
