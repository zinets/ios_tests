//
//  CPDOwnProfileEditPickerCell.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

/// ячейка, которая дает выбрать значения из пикера/барабана
class OwnProfileEditorPickerCell: OwnProfileEditorBaseCell {
    
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.dataSource = self
            picker.delegate = self
        }
    }
    /// цвет выбранной строки в пикере
    @IBInspectable var activeTextColor: UIColor = UIColor(red: 0.008, green: 0.569, blue: 0.953, alpha: 1)
    @IBInspectable var inactiveTextColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    fileprivate var dataSource: [[String]]!
    
    override func configure(_ item: AnyDiffAble) {
        super.configure(item)
        
        if let item = item.payload as? CPDOwnProfileEditorItem {
            self.picker.isHidden = !item.expanded
            
            dataSource = item.possibleValues
            
            self.updateValue()
            UIView.animate(withDuration: 0.2) {
                self.disclosureView.transform = item.expanded ? .init(rotationAngle: -CGFloat.pi / 2) : .init(rotationAngle: CGFloat.pi / 2)
            }
        }
    }
    
    fileprivate func updateValue() {
        self.valueLabel.text = self.dataSource.enumerated().map {
            dataSource[$0.offset][self.picker.selectedRow(inComponent: $0.offset)]
        }.joined(separator: " - ")
    }
    
}

extension  OwnProfileEditorPickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let color = row == pickerView.selectedRow(inComponent: component) ? activeTextColor : inactiveTextColor
        let attrString = NSAttributedString(string: dataSource[component][row], attributes: [NSAttributedString.Key.foregroundColor: color])
        return attrString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // я предполагаю, что диапазоны "от" и "до" совпадают, иначе это сплошной геморой и отстутствие смысла от слова "полностью"
        switch pickerView.numberOfComponents {
        case 2:
            // доп. проверка/выравнивание значений в барабанах
            if component == 0 && pickerView.selectedRow(inComponent: 1) < row {
                pickerView.selectRow(row, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            } else if component == 1 && pickerView.selectedRow(inComponent: 0) > row {
                pickerView.selectRow(row, inComponent: 0, animated: true)
                pickerView.reloadComponent(0)
            }
        default:
            break
        }
        pickerView.reloadComponent(component)
        self.updateValue()
        
        if let block = self.changeAction {
            // из ячейки с пикером я возвращаю массив выбранных индексов
            block(self.dataSource.enumerated().map {
                picker.selectedRow(inComponent: $0.offset)
            })
        }
    }
}
