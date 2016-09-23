//
//  Item.swift
//  testT1
//
//  Created by Zinets Victor on 9/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

import UIKit

let BLOCK_SIZE = 12
let HALF_BLOCK_SIZE = BLOCK_SIZE / 2

func blocksToPoints(x: Int) -> Int {
    return x * BLOCK_SIZE
}

enum ItemType {
    case Border
    case Empty
    case Square
    case Line
}

typealias Matrix = Array<Array<ItemType>>

class Item: NSObject {
    private var _xPoints = 0
    private var _yPoints = 0
    private var _matrix: Matrix?
    
    static func generateItem() -> Item {
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
        
        let newItem = Item()
        newItem._matrix = items[index]
        
        return newItem
    }
    
//    init(xPoints: Int, yPoints: Int) {
//        _xPoints = xPoints
//        _yPoints = yPoints
//    }
    override init () {
        super.init()
        _matrix = Array()
    }
    
    func isEmpty() -> Bool {
        let count = _matrix!.count
        return count == 0
    }
    
    func getSizeBlock() -> Int {
        return _matrix!.count
    }
    
    func rotate() {
        let size = getSizeBlock()
        var rotatedMatrix: Matrix = Matrix()

        for y in 0...(size - 1) {
            rotatedMatrix.append(Array())
            for x in 0...size - 1 {
                rotatedMatrix[y].append(_matrix![x][size - y - 1])
            }
        }
        _matrix = rotatedMatrix
    }
    
    func setPosition(xPoints: Int, yPoints: Int) {
        _xPoints = xPoints
        _yPoints = yPoints
    }
    
    func getXPoints() -> Int {
        return _xPoints
    }
    
    func getYPoints() -> Int {
        return _yPoints
    }
    
    func getBlockType(innerXBlocks: Int, innerYBlocks: Int) -> ItemType {
        let size = getSizeBlock()
        if (innerXBlocks < 0 || size <= innerXBlocks ||
            innerYBlocks < 0 || size <= innerYBlocks) {
            return .Empty
        } else {
            return _matrix![innerYBlocks][innerXBlocks]
        }
    }
    
    func getBlockXPoints(innerXBlocks: Int) -> Int {
        let innerXPoints = blocksToPoints(x: innerXBlocks) + HALF_BLOCK_SIZE
        let innerXCenterPoints = blocksToPoints(x: getSizeBlock()) / 2
        return _xPoints - innerXCenterPoints + innerXPoints
    }
    func getBlockYPoints(innerYBlocks:Int) -> Int {
        let innerYPoints = blocksToPoints(x: innerYBlocks) + HALF_BLOCK_SIZE
        let innerYCenterPoints = blocksToPoints(x: getSizeBlock()) / 2
        return _yPoints - innerYCenterPoints + innerYPoints
    }
}
