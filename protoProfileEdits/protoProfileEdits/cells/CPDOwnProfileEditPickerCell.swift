//
//  CPDOwnProfileEditPickerCell.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

class CPDOwnProfileEditPickerCell: CPDOwnProfileEditBaseCell {
    
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.dataSource = self
            picker.delegate = self
        }
    }
    
    fileprivate var dataSource: [[String]]!
    
    override func configure(_ item: AnyDiffAble) {
        super.configure(item)
        
        if let item = item.payload as? CPDOwnProfileEditorItem {
            self.picker.isHidden = !item.expanded
            
            switch item.type {
            case .gender:
                dataSource = [["Man", "Woman"]]
            case .age:
                let fromAge = (18...79).map{ String($0) }
                let toAge = (18...79).map{ String($0) }
                dataSource = [fromAge, toAge]
            default:
                fatalError("Nu ty ponyal")
            }
            
            UIView.animate(withDuration: 0.2) {
                self.disclosureView.transform = item.expanded ? .init(rotationAngle: -CGFloat.pi / 2) : .init(rotationAngle: CGFloat.pi / 2)
            }
        }
    }
    
}

extension  CPDOwnProfileEditPickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // я предполагаю, что диапазоны "от" и "до" совпадают, иначе это сплошной геморой и отстутствие смысла от слова "полностьб"
        if pickerView.numberOfComponents > 0 {
            // доп. проверка/выравнивание значений в барабанах
        }
        // TODO: сигналим, что значение поменялось
    }
}
