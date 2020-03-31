//
//  CPDOwnProfileEditorItem.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

struct CPDOwnProfileEditorItem: Item {
    var cellReuseId: String
    
    var title: String
    var value: String
    
    var expanded: Bool = false
    var editable: Bool = true
}
