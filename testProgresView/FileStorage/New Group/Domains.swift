//
//  Domains.swift
//  testProgresView
//
//  Created by Victor Zinets on 13.09.2022.
//

import Foundation

class StorageDomain {
    static var database = Database()
    static var oneTimeMigration = OneTimeLogic()
}

final class Database: Domain {
    override var keyName: String { "database" }
    
    lazy var user = { UserData(reverse: self) }()
    lazy var server = { ServerData(reverse: self) }()
}

private extension LastLevel {
    func data(_ keyName: String) -> LastField {
        LastField(value: keyName, reverse: self)
    }
}

final class UserData: LastLevel {
    override var keyName: String { "user" }
    
    lazy var firstLogin = { data("firstLogin") }()
    lazy var lastLogin = { data("lastLogin") }()
}

final class ServerData: LastLevel {
    override var keyName: String { "server" }
    
    lazy var sessionCount = { data("sessionCount") }()
    lazy var sessionTimeout = { data("sessionTimeout") }()
}

final class OneTimeLogic: Domain {
    override var keyName: String { "oneTimeMigration" }
    lazy var oneTimeCompleted = { LastField(value: "oneTimeCompleted", reverse: self) }()
}








