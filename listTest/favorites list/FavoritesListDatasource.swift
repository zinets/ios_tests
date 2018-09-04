//
//  FavoritesListDatasource.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class FavoritesListDatasource: TableSectionDatasource {
    
    override var supportedCellTypes: [CellType] {
        return [.TestFavoriteItem]        
    }    
    
    // MARK: cell creation -
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellId = CellsFactory.cellIdFor(.TestFavoriteItem)
//        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FavoritesListCell {
//            cell.fillData(items[indexPath.row])
//            return cell
//        }
//        
//        return UITableViewCell()
//    }
}
