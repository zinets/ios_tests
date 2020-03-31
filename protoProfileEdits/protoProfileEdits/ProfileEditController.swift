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
    
    private func updateDatasource() {
        var items: [AnyDiffAble] = []
        
        // screenName
        let screenNameItem = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditCell", type: .screenName, title: "Screenname", value: "Johm")
        items.append(AnyDiffAble(screenNameItem))
        // birth date
        var bdateItem = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditDateCell", type: .bdate, title: "Birth date", value: "12.08.1971")
        bdateItem.expanded = self.selectedItemType == .bdate
        items.append(AnyDiffAble(bdateItem))
        
        // gender
//        var genderItem = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditCell", type: .gender, title: "Gender", value: "Man")
//        genderItem.editable = false
//        items.append(AnyDiffAble(genderItem))
        
        // gender picker
        var genderpickerItem = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditPickerCell", type: .gender, title: "Gender", value: "Man")
        genderpickerItem.expanded = self.selectedItemType == .gender
        items.append(AnyDiffAble(genderpickerItem))
        
        // age picker
        var ageItem = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditPickerCell", type: .age, title: "Age", value: "20 - 40")
        ageItem.expanded = self.selectedItemType == .age
        items.append(AnyDiffAble(ageItem))
        
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
        switch item.type {
        case .screenName, .bdate, .gender, .age:
            self.updateDatasource()
        default:
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
