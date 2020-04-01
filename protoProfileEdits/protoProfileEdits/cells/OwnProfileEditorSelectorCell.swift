//
//  CPDOwnProfileEditCell.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

/// ячейка, которая просто ведет к экрану редактирования
class OwnProfileEditorSelectorCell: OwnProfileEditorBaseCell {
    
    override func configure(_ item: AnyDiffAble) {
        super.configure(item)
        if let item = item.payload as? CPDOwnProfileEditorItem {
            self.valueLabel.text = item.value
        }
    }

}
