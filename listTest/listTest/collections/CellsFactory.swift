//
//  CellsFactory.swift
//

import UIKit

class CellsFactory {
    
    // для регистрации кодом
    static func cellClassFor(_ cellType: CellType) -> AnyClass {
        switch cellType {
        case .TestPhotoItem:
            return PhotoCell.self
        case .TestFavoriteItem:
            return FavoritesListCell.self
        case .TestIntroFirst:
            return IntroCellFirst.self
        case .TestIntroOther:
            return IntroCellOther.self
        }
    }
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
