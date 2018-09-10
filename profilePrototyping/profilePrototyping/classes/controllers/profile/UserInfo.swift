//
//  UserInfo.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import Foundation

class UserInfo: Equatable, Hashable {
    var id: Int = 0
    var screenName: String = ""
    var age: Int = 0
    var location: String = ""
    var aboutDescription: String = ""
    var about = [String: String]()
    var photos = [String]()
    var onlineStatus: ProfileOnlineIndicatorView.OnlineState = .Offline
    
    public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue: Int {
        return self.id.hashValue
    }
}

class UserInfoAboutItem: Equatable, Hashable {
    var type: String = ""
    var value: String = ""
    
    public static func == (lhs: UserInfoAboutItem, rhs: UserInfoAboutItem) -> Bool {
        if lhs.type != rhs.type || lhs.value != rhs.value {
            return false
        }
        return true
    }
    
    var hashValue: Int {
        return type.hashValue ^ value.hashValue
    }
    
    init(_ type: String, value: String) {
        self.type = type
        self.value = value
    }
}
