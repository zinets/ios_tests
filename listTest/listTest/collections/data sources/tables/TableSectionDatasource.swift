//
//  TableSectionDatasource.swift
//

import UIKit

class TableSectionDatasource : SectionDatasource, UITableViewDataSource {
    var section: Int = 0
    var tableView: UITableView? {
        didSet {
            if let table = tableView {
                table.dataSource = self
                
                for cellType in supportedCellTypes {
                    let cellId = CellsFactory.cellIdFor(cellType)
                    if let cellNib = CellsFactory.cellNibFor(cellType) {
                        table.register(UINib(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellId)
                    }
                }
            }
        }
    }
    
    override var items: [DataSourceItem] {
        get {
            return super.items
        }
        set (newItems){
            super.items = newItems
            
            if let table = tableView {
                table.beginUpdates()
                
//                table.performBatchUpdates({
                
                    if (!toRemove.isEmpty) {
                        var array = [IndexPath]()
                        for index in toRemove {
                            array.append(IndexPath(item: index, section: section))
                        }
                        // TODO: consider to use performBatchUpdate
                        table.deleteRows(at: array, with: .automatic)
                    }
                    if (!toInsert.isEmpty) {
                        var array = [IndexPath]()
                        for index in toInsert {
                            array.append(IndexPath(item: index, section: section))
                        }
                        table.insertRows(at: array, with: .automatic)
                    }
                    if !toUpdate.isEmpty {
                        var array = [IndexPath]()
                        for index in toUpdate {
                            array.append(IndexPath(item: index, section: section))
                        }
                        table.reloadRows(at: array, with: .automatic)
                    }
                    
//                }) { (b) in
//
//                }
                
                table.endUpdates()
            }
        }
    }
    
    // MARK: tableview support -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = items[indexPath.item]
        let cellId = CellsFactory.cellIdFor(data.itemType)
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? DataAwareCell {
            cell.fillWithData(data)
            return cell as! UITableViewCell
        }
                
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}
