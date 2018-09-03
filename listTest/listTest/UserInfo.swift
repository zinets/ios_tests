//
//  UserInfo.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import Foundation

class UserInfo: Equatable, Hashable {
    var avatarUrl: String?
    var screenName: String?
    
    public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
//        if lhs.avatarUrl != rhs.avatarUrl {
//            return false
//        }
//        if lhs.screenName != rhs.screenName {
//            return false
//        }
//
//        return true
        return
            lhs.avatarUrl == rhs.avatarUrl &&
                lhs.screenName == rhs.screenName
    }
    
    init(screenName: String, avatarUrl: String) {
        self.screenName = screenName
        self.avatarUrl = avatarUrl
    }
    
    var hashValue: Int {
        var hash: Int = 0
        if let name = screenName {
            hash ^= name.hashValue
        }
        if let avatar = avatarUrl {
            hash ^= avatar.hashValue
        }
        
        return hash
    }
}
