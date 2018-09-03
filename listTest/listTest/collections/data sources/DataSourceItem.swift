//
//  DataSourceItem.swift
//

import UIKit

class DataSourceItem: Equatable, Hashable {
    let itemType: CellType
    var payload: AnyHashable?
    
    required init(_ itemType: CellType) {
        self.itemType = itemType
    }
    
    convenience init(_ itemType: CellType, payload: AnyHashable) {
        self.init(itemType)
        self.payload = payload
    }
    
    // MARK: protocols -
    
    public static func == (lhs: DataSourceItem, rhs: DataSourceItem) -> Bool {
        if lhs.itemType != rhs.itemType {
            return false
        }
        return lhs.payload == rhs.payload
    }
    
    var hashValue: Int {
        if let value = payload {
            // хз как тут надо будет сделать в итого
            return itemType.hashValue ^ value.hashValue
        } else {
            return itemType.hashValue
        }
    }
    
}
