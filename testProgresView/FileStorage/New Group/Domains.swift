//
//  Domains.swift
//  testProgresView
//
//  Created by Victor Zinets on 13.09.2022.
//

import Foundation

class StorageDomain {
    static var database = Database()
//    static var oneTimeMigration = OneTimeLogic()
}

final class Database: Domain {
    override var keyName: String { "database" }
    
    lazy var user = { UserData(reverse: self) }()
    lazy var server = { ServerData(reverse: self) }()
}

private extension MiddleLevel {
    func data(_ keyName: String) -> LastField {
        LastField(value: keyName, reverse: self)
    }
}

final class UserData: MiddleLevel {
    override var keyName: String { "user" }
    
    lazy var firstLogin = { data("firstLogin") }()
    lazy var lastLogin = { data("lastLogin") }()
    
    lazy var oneLimeLogic = { OneTimeLogic(reverse: self) }()
}

final class ServerData: MiddleLevel {
    override var keyName: String { "server" }
    
    lazy var sessionCount = { data("sessionCount") }()
    lazy var sessionTimeout = { data("sessionTimeout") }()
}

final class OneTimeLogic: MiddleLevel {
    override var keyName: String { "oneTimeLogic" }
    
    lazy var oneTimeCompleted = { LastField(value: "oneTimeCompleted", reverse: self) }()
    lazy var oneTimeConversion = { LastField(value: "oneTimeConversion", reverse: self) }()
    lazy var infoPopup = { LastField(value: "infoPopup", reverse: self) }()
}








