//
//  CellTypes.swift
//

import Foundation

enum CellType: String {
    // уговор - raw значение используется и как reuseCellID, и как имя для ксиба (и как имя класса, когда до этого дойдет)
    // а если надо будет как-то "нетак" - в свитче в CellsFactory можно порулить
    case TestPhotoItem = "PhotoCell"
    case TestFavoriteItem = "FavoritesListCell"
    
    case TestIntroFirst = "IntroCellFirst"
    case TestIntroOther = "IntroCellOther"
    // e.g.
//    case SearchUser
//    case GeoSearchUser
//    case MessageListItem
//    case SettingsItem
}
