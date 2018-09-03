//
//  FavoritesListDatasource.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class FavoritesListDatasource: TableSectionDatasource {
    
    let supportedCells: [CellType] = [.TestFavoriteItem /* , .VIPFavoriteItem для какого-то супер-юзера,  */]
    
    override var tableView: UITableView? {
        didSet {
            if let table = tableView {
                for cellType in supportedCells {
                    let cellId = CellsFactory.cellIdFor(cellType)
                    let cellNib = CellsFactory.cellNibFor(cellType)
                    
                    table.register(UINib(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellId)
                }
            }
        }
    }
    
    // MARK: cell creation -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = CellsFactory.cellIdFor(.TestFavoriteItem)
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FavoritesListCell {
            cell.fillData(items[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}
