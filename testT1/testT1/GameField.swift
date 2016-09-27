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
    let cellSize = 12
    
    func updateField(model: GameModel) {
        gameModel = model
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        if let model = gameModel {
            let context = UIGraphicsGetCurrentContext()
            
            var cols = model.numberOfCols()
            var rows = model.numberOfRows()
            
            let cellW = Int(self.bounds.size.width) / cols
            let cellH = Int(self.bounds.size.height) / rows
            
            for y in 0..<rows {
                for x in 0..<cols {
                    let frm = CGRect(x: x * cellW, y: y * cellH, width: cellW, height: cellH)
                    
                    var fillColor = UIColor.blue.cgColor
                    
                    switch model.getBlockType(xBlocks: x, yBlocks: y) {
                    case .Empty:
                        fillColor = UIColor.red.cgColor
                    case .Border:
                        fillColor = UIColor.black.cgColor
                    default:
                        break;
                    }
                    
                    context!.setFillColor(fillColor)
                    context!.fill(frm)
                    
                    context!.setStrokeColor(UIColor.red.cgColor)
                    context!.setLineWidth(4)
                    context!.stroke(frm)
                }
            }
            
            let item = model.getItem()
            rows = item.getSizeBlock()
            cols = rows
            
            for y in 0..<rows {
                for x in 0..<cols {
                    let frm = CGRect(x: item.getXPoints() / cellSize * cellW + x * cellW,
                                     y: item.getYPoints() / cellSize * cellH + y * cellH,
                                     width: cellW, height: cellH)
                    
                    if item.getBlockType(innerXBlocks: x, innerYBlocks: y) != .Empty {
                        let fillColor = UIColor.red.cgColor

                        context!.setFillColor(fillColor)
                        context!.fill(frm)
                        
                        context!.setStrokeColor(UIColor.gray.cgColor)
                        context!.setLineWidth(4)
                        context!.stroke(frm)
                    }
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
