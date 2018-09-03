//
//  TableSectionDatasource.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class TableSectionDatasource : SectionDatasource, UITableViewDataSource {
    var section: Int = 0
    var tableView: UITableView? {
        didSet {
            if let table = tableView {
                table.dataSource = self
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
            }
        }
    }
    
    // MARK: tableview support -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
