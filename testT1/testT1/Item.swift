//
//  Item.swift
//  testT1
//
//  Created by Zinets Victor on 9/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

import UIKit

enum ItemType {
    case Empty
    case Square
    case Line
}

typealias Matrix = Array<Array<ItemType>>

class Item: NSObject {
    private var _xPoints = 0
    private var _yPoints = 0
    private var _matrix: Matrix
    
    init(xPoints: Int, yPoints: Int) {
        _xPoints = xPoints
        _yPoints = yPoints
        
        let items: Array<Matrix> = [
            [ // Box
                [.Square, .Square],
                [.Square, .Square],
                ],
            [ // Line
                [.Empty, .Line, .Empty, .Empty],
                [.Empty, .Line, .Empty, .Empty],
                [.Empty, .Line, .Empty, .Empty],
                [.Empty, .Line, .Empty, .Empty],
                ]
        ]
        
        let count: UInt32 = UInt32(items.count)
        let index = Int(arc4random_uniform(count))
        
        _matrix = items[index]
    }
    
    func getSizeBlock() -> Int {
        return _matrix.count
    }
    
    func rotate() {
        var rotatedMatrix: Matrix = Matrix(getSizeBlock())
        
    }
}
