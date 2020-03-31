//
//  CPDOwnProfileEditDateCell.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

class CPDOwnProfileEditDateCell: CPDOwnProfileEditBaseCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func configure(_ item: AnyDiffAble) {
        super.configure(item)
        
        if let item = item.payload as? CPDOwnProfileEditorItem {
            self.datePicker.isHidden = !item.expanded
        }
    }
}

class CPDOwnProfileEditPickerCell: CPDOwnProfileEditBaseCell {
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func configure(_ item: AnyDiffAble) {
        super.configure(item)
        
        if let item = item.payload as? CPDOwnProfileEditorItem {
            self.picker.isHidden = !item.expanded
        }
    }
}
