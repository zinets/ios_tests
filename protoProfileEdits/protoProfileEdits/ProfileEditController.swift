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
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
        }
    }
    
    private lazy var dataSource: TableDiffAbleDatasource<Sections, AnyDiffAble> = {
        let ds = TableDiffAbleDatasource<Sections, AnyDiffAble>(tableView: self.tableView) { (cell, item) in
            if let cell = cell as? AnyDiffAbleControl {
                cell.configure(item)
            }
        }
        return ds
    }()
    
    //  по тапу я буду запоминать тип, при заполнении датасорца буду соотв. определять какой итем должен быть "раскрыт" (если он в принципе может быть раскрыт
    private var selectedItemType: CPDOwnProfileEditorItem.EditorType?
    
    private func item(for type: CPDOwnProfileEditorItem.EditorType) -> CPDOwnProfileEditorItem {
        switch type {
        case .screenName:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditCell", type: type, title: "Screenname", value: "Johm")
            item.expandable = false
            return item
        case.age:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditPickerCell", type: type, title: "User age", value: "39")
            item.expanded = self.selectedItemType == item.type
            return item
        case .gender:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditCell", type: type, title: "Gender", value: "Man")
            item.editable = false
            item.expandable = false
            return item
        case .lookingGender:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditPickerCell", type: type, title: "Gender", value: "Man")
            item.expanded = self.selectedItemType == item.type
            return item
        case .lookingAge:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditPickerCell", type: type, title: "Age", value: "20 - 40")
            item.expanded = self.selectedItemType == type
            return item
        default:
            fatalError()
        }
    }
    
    private func updateDatasource() {
        var items: [AnyDiffAble] = []
        
        // screenName
        items.append(AnyDiffAble(self.item(for: .screenName)))
        // user age
        items.append(AnyDiffAble(self.item(for: .age)))
        // gender
        items.append(AnyDiffAble(self.item(for: .gender)))
        // gender picker
        items.append(AnyDiffAble(self.item(for: .lookingGender)))        
        // age picker
        items.append(AnyDiffAble(self.item(for: .lookingAge)))
        
        self.dataSource.beginUpdates()
        self.dataSource.appendSections([.first])
        self.dataSource.appendItems(items, toSection: .first)
        self.dataSource.endUpdates(true)
    }

}

extension ProfileEditController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.dataSource.item(for: indexPath)?.payload as? CPDOwnProfileEditorItem else {
            return
        }
        
        self.selectedItemType = (self.selectedItemType != item.type) ? item.type : nil
        self.updateDatasource()
        if !item.expandable {
            tableView.deselectRow(at: indexPath, animated: false)
        }

    }
}
