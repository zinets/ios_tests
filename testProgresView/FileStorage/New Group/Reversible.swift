//
//  Reversible.swift
//  testProgresView
//
//  Created by Victor Zinets on 13.09.2022.
//

import Foundation

public protocol Reversible: AnyObject {
    var reverse: Reversible? { get }
    var keyName: String { get }
}

class Domain: Reversible {
    public private(set) var reverse: Reversible?
    var keyName: String { fatalError() }
}

class MiddleLevel: Reversible {
    public private(set) weak var reverse: Reversible?
    init(reverse: Reversible) {
        self.reverse = reverse
    }
    var keyName: String { fatalError() }
}

final class LastField: Reversible {
    private var intValue: String
    public private(set) weak var reverse: Reversible?
    
    init(value: String, reverse: Reversible) {
        self.reverse = reverse
        self.intValue = value
    }
    
    var keyName: String { intValue }
}
