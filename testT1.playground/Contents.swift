//: Playground - noun: a place where people can play

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
        let index = 1;//Int(arc4random_uniform(count))
        
        _matrix = items[index]
    }
    
    func getSizeBlock() -> Int {
        return _matrix.count
    }
    
    func rotate() {
        let size = getSizeBlock()
        var rotatedMatrix: Matrix = Matrix()
        
        for y in 0...(size - 1) {
            rotatedMatrix.append(Array())
            for x in 0...size - 1 {
                rotatedMatrix[y].append(_matrix[x][size - y - 1])
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
            return _matrix[innerYBlocks][innerXBlocks]
        }
    }
}


let item = Item(xPoints: 0, yPoints: 0)
item.getBlockType(innerXBlocks: 1, innerYBlocks: 2)



