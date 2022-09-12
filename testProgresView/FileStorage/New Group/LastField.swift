//
//  LastField.swift
//  testProgresView
//
//  Created by Victor Zinets on 12.09.2022.
//

import Foundation

final class LastField: CustomStringConvertible {
    private var intValue: String
    private weak var reverse: MiddleLevel?
    
    init(value: String, reverse: MiddleLevel) {
        self.reverse = reverse
        self.intValue = value
    }
    
    var description: String {
        return reverse!.description + intValue
    }
}
