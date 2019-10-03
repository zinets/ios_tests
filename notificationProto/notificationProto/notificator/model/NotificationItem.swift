//
//  NotificationItem.swift
//  test1
//
//  Created by Viktor Zinets on 10/2/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import DiffAble

class NotificationItem: NSObject, Item {
    
    public private (set) var cellReuseId: String
        
    override init() {
        fatalError()
    }
    
    init(with cellReuseId: String) {
        self.cellReuseId = cellReuseId
        super.init()
    }
        
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? NotificationItem else {
            return false
        }
        let res = object.cellReuseId == cellReuseId
            && notificationText == object.notificationText
            && notificationAge == object.notificationAge        
        
        return res
    }
    
    // все строчки формируются на "той" стороне
    var notificationText: String! // TODO: attributed string
    var notificationAge: String!
    
    var avatarUrl: String?
    var placeholder: String? // имя файла для пласхолдера?
//    var notificationType: // TODO: взять что-то из готовых типов?
    
    // нет смысла городить из-за вынесения одной проперти
    var counter: Int = 2
}

