//
//  CPDOwnProfileEditorItem.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

struct CPDOwnProfileEditorItem: Item {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.cellReuseId == rhs.cellReuseId
            && lhs.type == rhs.type
            && lhs.title == rhs.title
            && lhs.value == rhs.value
            && lhs.expanded == rhs.expanded
    }    
    
    enum EditorType {
        case screenName, age, location, gender /* read only */
        case lookingAge, lookingGender, lookingLocation
        case smoke, drink, about
    }
    var cellReuseId: String
    var type: EditorType
    
    var title: String
    var value: String
    
    var expanded: Bool = false
    var expandable: Bool = true
    var editable: Bool = true
    
    var onDataChange: (() -> ())?
}

extension CPDOwnProfileEditorItem.EditorType {
    
    var dataSource: [[String]]? {
        switch self {
        case .age:
            return [(18...79).map{ String($0) }]
        case .lookingAge:
            let fromAge = (18...79).map{ String($0) }
            let toAge = (18...79).map{ String($0) }
            return [fromAge, toAge]
        case .gender, .lookingGender:
            return [["Man", "Woman"]]
        default:
            return nil
        }
    }
}
