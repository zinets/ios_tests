//
//  MiddleLevel.swift
//  testProgresView
//
//  Created by Victor Zinets on 12.09.2022.
//

import Foundation

class MiddleLevel: CustomStringConvertible {
    private weak var reverse: Domain?
    init(reverse: Domain) {
        self.reverse = reverse
    }
    var description: String { reverse!.description + "user." }
    
    fileprivate func data(_ keyName: String) -> LastField { LastField(value: keyName, reverse: self) }
}








final class UserData: MiddleLevel {
    lazy var firstLogin = { data("firstLogin") }()
    lazy var lastLogin = { data("lastLogin") }()
}

final class ServerData: MiddleLevel {
    lazy var sessionCount = { data("sessionCount") }()
    lazy var sessionTimeout = { data("sessionTimeout") }()
}

