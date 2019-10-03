//
//  NotificationItem.swift
//  test1
//
//  Created by Viktor Zinets on 10/2/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import DiffAble

class TableItem: NSObject, Item {
    
    public private (set) var cellReuseId: String
    var index: Int = 0
    
    override init() {
        fatalError()
    }
    
    init(with cellReuseId: String) {
        self.cellReuseId = cellReuseId
        super.init()
    }
        
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? TableItem else {
            return false
        }
        let res = object.cellReuseId == cellReuseId && object.index == index
        
        return res
    }
}
