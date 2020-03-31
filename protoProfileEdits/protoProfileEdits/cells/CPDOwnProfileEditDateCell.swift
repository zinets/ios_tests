//
//  CPDOwnProfileEditDateCell.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

class CPDOwnProfileEditDateCell: CPDOwnProfileEditBaseCell {
    
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: UIControl.Event.valueChanged)
        }
    }
    
    override func configure(_ item: AnyDiffAble) {
        super.configure(item)
        
        if let item = item.payload as? CPDOwnProfileEditorItem {
            self.datePicker.isHidden = !item.expanded
            
            UIView.animate(withDuration: 0.2) {
                self.disclosureView.transform = item.expanded ? .init(rotationAngle: -CGFloat.pi / 2) : .init(rotationAngle: CGFloat.pi / 2)
            }
        }
    }
    
    // MARK: actions -
    @objc private func dateChanged(_ sender: UIDatePicker) {
        
    }
}

