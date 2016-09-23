//
//  GameField.swift
//  testT1
//
//  Created by Zinets Victor on 9/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

import UIKit

class GameField: UIView {
    var gameModel: GameModel?
    let cellSize = 12.0
    
    func updateField(model: GameModel) {
        gameModel = model
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        if let model = gameModel {
            let context = UIGraphicsGetCurrentContext()
            
            let cols = model.numberOfCols()
            let rows = model.numberOfRows()
            
            let cellW = Int(self.bounds.size.width) / cols
            let cellH = Int(self.bounds.size.height) / rows
            
            for y in 0..<rows {
                for x in 0..<cols {
                    let frm = CGRect(x: x * cellW, y: y * cellH, width: cellW, height: cellH)
                    
                    var fillColor = UIColor.blue.cgColor
                    if model.getBlockType(xBlocks: x, yBlocks: y) != .Empty {
                        fillColor = UIColor.red.cgColor
                    }
                    context!.setFillColor(fillColor)
                    context!.fill(frm)
                    
                    context!.setStrokeColor(UIColor.red.cgColor)
                    context!.setLineWidth(4)
                    context!.stroke(frm)
                }
            }
        }
        
//        context!.setFillColor(UIColor.gray.cgColor)
//        context!.fill(rect)
//        
//        context!.setStrokeColor(UIColor.blue.cgColor)
//        context!.addRect(rect)
//        context!.setLineWidth(4)
//        context!.strokePath()
    }
}
