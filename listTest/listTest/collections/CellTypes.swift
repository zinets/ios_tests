//
//  CellTypes.swift
//

import Foundation

enum CellType: String {
    // уговор - raw значение используется и как reuseCellID, и как имя для ксиба (и как имя класса, когда до этого дойдет)
    // а если надо будет как-то "нетак" - в свитче в CellsFactory можно порулить
    case ProfileAboutItem = "ProfileAboutItem"
    
}

// ячейка должна уметь показать переданные ей данные
protocol DataAwareCell {
    func fillWithData(_ data: DataSourceItem)
}
