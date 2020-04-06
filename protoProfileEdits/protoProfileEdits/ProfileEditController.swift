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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateDatasource()
    }
    
    // MARK: keyboard handling -
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @objc private func keyboardHeightChange(notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
            let oldFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
            let newFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            else { return }
        
        let height = oldFrame.cgRectValue.origin.y - newFrame.cgRectValue.origin.y
        bottomConstraint?.constant += height
        
        UIView.animate(withDuration: duration, delay: TimeInterval(0), options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: datasource -
    enum Sections { case first }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
        }
    }
    
    private lazy var dataSource: TableDiffAbleDatasource<Sections, AnyDiffAble> = {
        let ds = TableDiffAbleDatasource<Sections, AnyDiffAble>(tableView: self.tableView) {
            ($0 as! AnyDiffAbleControl).configure($1)
//            (cell, item) in
//            if let cell = cell as? AnyDiffAbleControl {
//                cell.configure(item)
//            }
        }
        return ds
    }()
    
    //  по тапу я буду запоминать тип, при заполнении датасорца буду соотв. определять какой итем должен быть "раскрыт" (если он в принципе может быть раскрыт
    private var selectedItemType: EditorType?
        
    private var genderValues: [String] = ["Man", "Woman"]
    private var agesValues: [String] = (18...78).map { String($0) }

    private func updateDatasource() {
        var items: [AnyDiffAble] = []
        
        // screenname
        let item = CPDOwnProfileEditorPushItem(cellReuseId: OwnProfileEditorPushCell.reuseCellId, type: .screenName, title: "Screenname", value: "John")
        items.append(AnyDiffAble(item))
                
        // age
        var ageItem = CPDOwnProfileEditorSelectorItem(cellReuseId: OwnProfileEditorPickerCell.reuseCellId, type: .age, title: "Age")
        ageItem.expandable = true
        ageItem.expanded = self.selectedItemType == .age
        ageItem.possibleValues = [self.agesValues]
        items.append(AnyDiffAble(ageItem))
        
        // gender
        var genderItem = CPDOwnProfileEditorSelectorItem(cellReuseId: OwnProfileEditorPickerCell.reuseCellId, type: .gender, title: "Gender")
        genderItem.editable = false
        genderItem.possibleValues = [self.genderValues]
        items.append(AnyDiffAble(genderItem))
        
        // looking for gender
        var lookingGenderItem = CPDOwnProfileEditorSelectorItem(cellReuseId: OwnProfileEditorPickerCell.reuseCellId, type: .lookingGender, title: "looking for Gender")
        lookingGenderItem.editable = true
        lookingGenderItem.expandable = true
        lookingGenderItem.expanded = self.selectedItemType == .lookingGender
        lookingGenderItem.possibleValues = [self.genderValues]
        items.append(AnyDiffAble(lookingGenderItem))
        
        // looking ages
        var lookingAge = CPDOwnProfileEditorSelectorItem(cellReuseId: OwnProfileEditorPickerCell.reuseCellId, type: .lookingAge, title: "Looking for age")
        lookingAge.expanded = self.selectedItemType == lookingAge.type
        lookingAge.possibleValues = [self.agesValues, self.agesValues]
        items.append(AnyDiffAble(lookingAge))
        
        // text about
        var aboutItem = CPDOwnProfileEditorTextItem(cellReuseId: OwnProfileEditorTextCell.reuseCellId, type: .about, title: "About", value: "100 % mudozvon")
        aboutItem.onDataChange = { (newValue) in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            print(newValue as? String)
        }
        items.append(AnyDiffAble(aboutItem))
        
        
        self.dataSource.beginUpdates()
        self.dataSource.appendSections([.first])
        self.dataSource.appendItems(items, toSection: .first)
        self.dataSource.endUpdates(true)
    }
    

}

extension ProfileEditController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.dataSource.item(for: indexPath)?.payload as? OwnProfileEditorItem else {
            return
        }

        self.selectedItemType = (self.selectedItemType != item.type) ? item.type : nil
        self.updateDatasource()
        if !item.expandable {
            tableView.deselectRow(at: indexPath, animated: false)
        }

    }
}
