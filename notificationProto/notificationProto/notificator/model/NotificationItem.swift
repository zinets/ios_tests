//
//  NotificationItem.swift
//
//  Created by Viktor Zinets on 10/2/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import DiffAble

enum NotificationItemType {
    case visitor, video, photo, like, chat // смысла вводить свой тип мало, но для отладки/прототипа так проще
    
    var backgroundColor: Int {
        switch self {
        case .chat: return 0x2a76d3
        case .visitor: return 0x9675ce
        case .photo: return 0x64b5f6
        case .video: return 0xff9802
        case .like: return 0xf2709c
        }
    }
    
    var imageName: String {
        switch self {
        case .chat: return "notifChat"
        case .visitor: return "notifVisitor"
        case .photo: return "notifPhoto"
        case .video: return "notifVideo"
        case .like: return "notifLike"
        }
    }
}

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
    var notificationText: NSAttributedString! // TODO: attributed string
    var notificationAge: String!
    
    var avatarUrl: String?
    var placeholder: String? // имя файла для пласхолдера?
    var notificationType: NotificationItemType!
}

class NotificationGroupedItem: NotificationItem {
    var counter: Int = 2
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? NotificationGroupedItem else {
            return false
        }
        guard object.counter == counter else {
            return false
        }
        
        return super.isEqual(object)
    }
}
