//
//  GameModel.swift
//  testT1
//
//  Created by Zinets Victor on 9/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

import UIKit

let MAX_TOUCH_COUNT = 20

class GameModel: NSObject {
    private var matrix: Matrix?
    private var activeItem: Item
    private var gameOver = false
    private var itemBottomTouchCounter = 0
    
    override init() {
        activeItem = Item()
        super.init()
        resetGame()
    }
    
    func numberOfRows() -> Int {
        return 4
    }
    func numberOfCols() -> Int {
        return 4
    }

    func resetGame() {
        matrix = [
            [.Empty, .Empty, .Empty, .Empty],
            [.Empty, .Empty, .Empty, .Empty],
            [.Empty, .Empty, .Empty, .Empty],
            [.Empty, .Empty, .Empty, .Empty]
        ]
        activeItem = Item()
    }
    
    func getBlockType(xBlocks: Int, yBlocks: Int) -> ItemType {
        if xBlocks < 0 || numberOfCols() <= xBlocks ||
            numberOfRows() <= yBlocks {
            return .Border;
        } else if yBlocks < 0 {
            return .Empty;
        } else {
            return matrix![yBlocks][xBlocks];
        }
    }
    
    func hasCollision(xPoints: Int, yPoints: Int) -> Bool {
        let xBlocks = xPoints < 0 ? -1 : (xPoints / BLOCK_SIZE)
        let yTopBlocks = yPoints - HALF_BLOCK_SIZE
        if (getBlockType(xBlocks: xBlocks, yBlocks: yTopBlocks / BLOCK_SIZE) != .Empty) {
            return true
        }
        let yBottomBlocks = yPoints + HALF_BLOCK_SIZE;
        if yTopBlocks % BLOCK_SIZE != 0 && getBlockType(xBlocks: xBlocks, yBlocks: yBottomBlocks / BLOCK_SIZE) != .Empty {
            return true
        }
        
        return false;
    }

    func hasCollision(item: Item) -> Bool {
        for xBlocks in 0 ..< item.getSizeBlock() {
            for yBlocks in 0..<item.getSizeBlock() {
                if (item.getBlockType(innerXBlocks: xBlocks, innerYBlocks: yBlocks) != .Empty &&
                    hasCollision(xPoints: item.getBlockXPoints(innerXBlocks: xBlocks), yPoints: item.getBlockYPoints(innerYBlocks: yBlocks))) {
                    return true
                }
            }
        }
        return false
    }
    
    func isGameOver() -> Bool {
        return gameOver
    }
    
    func doStep() {
        if (activeItem.isEmpty()) {
            activeItem = Item.generateItem()
            var xPoints = blocksToPoints(x: (numberOfCols() / 2))
            if (activeItem.getSizeBlock() % 2 == 1) {
                xPoints += HALF_BLOCK_SIZE
            }
            activeItem.setPosition(xPoints: xPoints, yPoints: 0)
            if (hasCollision(item: activeItem)) {
                gameOver = true
            }
        }
        if isGameOver() {
            return
        }
        
        let speed = 10
        let item = activeItem
        item.setPosition(xPoints: activeItem.getXPoints(), yPoints: activeItem.getYPoints() + speed)
        if (!hasCollision(item: item)) {
            activeItem = item
            itemBottomTouchCounter = 0
        } else {
            while (hasCollision(item: item)) {
                item.setPosition(xPoints: item.getXPoints(), yPoints: item.getYPoints() - 1)
            }
            
            if MAX_TOUCH_COUNT < itemBottomTouchCounter {
                activeItem = Item();
                for xBlocks in 0..<item.getSizeBlock() {
                    for yBlocks in 0..<item.getSizeBlock() {
                        let blockType = item.getBlockType(innerXBlocks: xBlocks, innerYBlocks: yBlocks)
                        if( blockType != .Empty ) {
                            let xPoints = item.getBlockXPoints(innerXBlocks: xBlocks)
                            let yPoints = item.getBlockYPoints(innerYBlocks: yBlocks);
                            matrix?[yPoints / BLOCK_SIZE][xPoints / BLOCK_SIZE] = blockType;
                        }
                    }
                }
//                clean(); - очистка полностью заполненых рядов
            } else {
                activeItem = item;
                itemBottomTouchCounter += 1;
            }
        }
    }
}
