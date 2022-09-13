//
//  Domains.swift
//  testProgresView
//
//  Created by Victor Zinets on 13.09.2022.
//

import Foundation

class StorageKeys {
    static var database = Database()
//    static var oneTimeMigration = OneTimeLogic()
}



final class Database: Domain {
    override var keyName: String { "database" }
    
    lazy var user = { UserData(reverse: self) }()
    lazy var server = { ServerData(reverse: self) }()
}



final class UserData: MiddleLevel {
    override var keyName: String { "user" }
    
    lazy var firstLogin = { LastField(value: "firstLogin", reverse: self) }()
    lazy var lastLogin = { LastField(value: "lastLogin", reverse: self) }()
    
    lazy var oneLimeLogic = { OneTimeLogic(reverse: self) }()
}

final class ServerData: MiddleLevel {
    override var keyName: String { "server" }
    
    lazy var sessionCount = { LastField(value: "sessionCount", reverse: self) }()
    lazy var sessionTimeout = { LastField(value: "sessionTimeout", reverse: self) }()
}

final class OneTimeLogic: MiddleLevel {
    override var keyName: String { "oneTimeLogic" }
    
    lazy var oneTimeCompleted = { LastField(value: "oneTimeCompleted", reverse: self) }()
    lazy var oneTimeConversion = { LastField(value: "oneTimeConversion", reverse: self) }()
    lazy var infoPopup = { LastField(value: "infoPopup", reverse: self) }()
}








