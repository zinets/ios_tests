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
        let ds = TableDiffAbleDatasource<Sections, AnyDiffAble>(tableView: self.tableView) { (cell, item) in
            if let cell = cell as? AnyDiffAbleControl {
                cell.configure(item)
            }
        }
        return ds
    }()
    
    //  по тапу я буду запоминать тип, при заполнении датасорца буду соотв. определять какой итем должен быть "раскрыт" (если он в принципе может быть раскрыт
    private var selectedItemType: CPDOwnProfileEditorItem.EditorType?
    
    private var genderValues: [String] = ["Man", "Woman"]
    private var agesValues: [String] = (18...78).map { String($0) }
    
    private func item(for type: CPDOwnProfileEditorItem.EditorType) -> CPDOwnProfileEditorItem {
        switch type {
        case .screenName:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditSelectorCell", type: type, title: "Screenname", value: "Johm")
            item.expandable = false
            return item
        case.age:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditPickerCell", type: type, title: "User age", value: "39")
            item.possibleValues = [self.agesValues]
            
            item.expanded = self.selectedItemType == item.type
            item.onDataChange = { values in
                guard let values = values as? [Int] else { return }
                values.enumerated().forEach { (element) in
                    print(element.element)
                }
            }
            return item
        case .gender:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditSelectorCell", type: type, title: "Gender", value: "Man")
            item.editable = false
            item.expandable = false
            return item
        case .lookingGender:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditPickerCell", type: type, title: "Gender", value: "Man")
            item.possibleValues = [self.genderValues]
            
            item.expanded = self.selectedItemType == item.type
            item.onDataChange = { values in
                guard let values = values as? [Int] else { return }
                values.enumerated().forEach { [weak self] (element) in
                    print("selected gender: \(self?.genderValues[element.element])")
                }
            }
            return item
        case .lookingAge:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditPickerCell", type: type, title: "Age", value: "20 - 40")
            item.possibleValues = [self.agesValues, self.agesValues]
            
            item.expanded = self.selectedItemType == type
            item.onDataChange = { [weak self] values in
                guard let values = values as? [Int] else { return }
                
                let fromAge = self?.agesValues[values[0]]
                let toAge = self?.agesValues[values[1]]
                print("new looking for age: from \(fromAge) to \(toAge)")
            }
            return item
        case .about:
            var item = CPDOwnProfileEditorItem(cellReuseId: "CPDOwnProfileEditTextCell", type: type, title: "About me", value: "100 % blah-blah-blah")
            
            item.expandable = true
            item.onDataChange = { (newValue) in
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                print(newValue as? String)
            }
            return item
        default:
            fatalError()
        }
    }
    
    private func updateDatasource() {
        let items: [CPDOwnProfileEditorItem.EditorType] = [.screenName, .age, .gender,
                                                           .lookingGender, .lookingAge, .about]
                
        self.dataSource.beginUpdates()
        self.dataSource.appendSections([.first])
        self.dataSource.appendItems(items.map{ AnyDiffAble(self.item(for: $0)) },
                                    toSection: .first)
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
