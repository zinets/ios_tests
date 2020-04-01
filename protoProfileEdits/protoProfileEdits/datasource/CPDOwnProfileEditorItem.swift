//
//  CPDOwnProfileEditorItem.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

enum EditorType {
    case screenName, age, location, gender /* read only */
    case lookingAge, lookingGender, lookingLocation
    case smoke, drink, about
}

// базовые свойства ячейки редактирования профиля - тип, разворачиваемость etc
protocol OwnProfileEditorItem {
    var type: EditorType { get set }
    
    var expanded: Bool { get set }
    var expandable: Bool { get set }
}

protocol OwnProfileEditableItem {
    var editable: Bool { get set } // засеривает значение и скрывает стрелку для нередактируемых полей
    // тут прикольно было бы возвращать саму структуру, ту ее часть, которая нужна конкретному варианту (Text, Selector, MultiSelector протоколы)
    var onDataChange: ((Any?) -> ())? { get set }
}

// ячейка, которая просто переводит на следующий экран к редактированию
protocol OwnProfileEditorPushItem {
    var title: String { get set }
    var value: String { get set }
}

// ячейка, которая дает выбирать одно значение (радиобатон или барабан - раз барабан, то может быть > 1 набора для выбора)
protocol OwnProfileSelectorItem {
    var title: String { get set }
    var value: String? { get set }

    var possibleValues: [[String]]? { get set }
}

// ячейка для ввода текста
protocol OwnProfileEditorTextItem {
    var title: String { get set }
    var value: String { get set }
}




struct CPDOwnProfileEditorPushItem: Item, OwnProfileEditorItem, OwnProfileEditorPushItem {
    
    var cellReuseId: String
    
    var type: EditorType
    var expanded: Bool = false
    var expandable: Bool = false
            
    var title: String
    var value: String
    
    static func == (lhs: CPDOwnProfileEditorPushItem, rhs: CPDOwnProfileEditorPushItem) -> Bool {
        return
            lhs.cellReuseId == rhs.cellReuseId &&
            lhs.type == rhs.type &&
            lhs.expanded == rhs.expanded &&
            lhs.value == rhs.value
    }
}


struct CPDOwnProfileEditorSelectorItem: Item, OwnProfileEditorItem, OwnProfileSelectorItem, OwnProfileEditableItem {
    
    var cellReuseId: String
    
    var type: EditorType
    var expanded: Bool = false
    var expandable: Bool = true
    
    var title: String
    var value: String?
    var possibleValues: [[String]]?
    
    static func == (lhs: CPDOwnProfileEditorSelectorItem, rhs: CPDOwnProfileEditorSelectorItem) -> Bool {
        return
            lhs.cellReuseId == rhs.cellReuseId &&
            lhs.type == rhs.type &&
            lhs.expanded == rhs.expanded &&
            lhs.value == rhs.value
    }

    var editable: Bool = true
    var onDataChange: ((Any?) -> ())?
}

struct CPDOwnProfileEditorTextItem: Item, OwnProfileEditorItem, OwnProfileEditorTextItem, OwnProfileEditableItem {
    
    var cellReuseId: String
    
    var type: EditorType
    var expanded: Bool = false
    var expandable: Bool = true
            
    var title: String
    var value: String
    
    var editable: Bool = true
    var onDataChange: ((Any?) -> ())?
    
    static func == (lhs: CPDOwnProfileEditorTextItem, rhs: CPDOwnProfileEditorTextItem) -> Bool {
        return
            lhs.cellReuseId == rhs.cellReuseId &&
            lhs.type == rhs.type &&
            lhs.expanded == rhs.expanded &&
            lhs.value == rhs.value
    }
}
