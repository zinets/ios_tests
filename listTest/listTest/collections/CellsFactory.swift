//
//  CellsFactory.swift
//

import UIKit

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
