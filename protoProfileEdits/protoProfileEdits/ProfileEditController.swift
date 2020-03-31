//
//  ViewController.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

class ProfileEditController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateDatasource()
    }

    
    // MARK: datasource -
    enum Sections { case first }
    @IBOutlet weak var tableView: UITableView!
    private lazy var dataSource: TableDiffAbleDatasource<Sections, AnyDiffAble> = {
        let ds = TableDiffAbleDatasource<Sections, AnyDiffAble>(tableView: self.tableView) { (cell, item) in
            if let cell = cell as? AnyDiffAbleControl {
                cell.configure(item)
            }
        }
        return ds
    }()
    
    private func updateDatasource() {
        var items: [AnyDiffAble] = []
        
        // screenName
        let screenNameItem = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditCell", title: "Screenname", value: "Johm")
        items.append(AnyDiffAble(screenNameItem))
        
        // gender
        var genderItem = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditCell", title: "Gender", value: "Man")
        genderItem.editable = true
        genderItem.expanded = true
        items.append(AnyDiffAble(genderItem))
        
        self.dataSource.beginUpdates()
        self.dataSource.appendSections([.first])
        self.dataSource.appendItems(items, toSection: .first)
        self.dataSource.endUpdates(false)
    }

}

