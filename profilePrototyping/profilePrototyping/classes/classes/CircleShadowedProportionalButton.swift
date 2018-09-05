//
//  CircleShadowedProportionalButton.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

/// кнопка а) круглая б) отбрасывает тень в) при масштабировании увеличивает размер иконки
class CircleShadowedProportionalButton: UIButton {
    
    private var maskLayer: CAShapeLayer?
    private var bgColor = UIColor.white

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgColor = self.backgroundColor!
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layer = maskLayer {
            layer.path = UIBezierPath(ovalIn: bounds).cgPath
        } else {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor(rgb: 0x7c30fe).cgColor
            layer.shadowColor = UIColor(rgb: 0x7c30fe).cgColor
            layer.shadowRadius = 16
            layer.shadowOpacity = 0x4c / 0xff
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.path = UIBezierPath(ovalIn: bounds).cgPath
            
            maskLayer = layer
            
            self.layer.insertSublayer(maskLayer!, at: 0)
        }
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let w = contentRect.size.width / 3
        let h = contentRect.size.height / 3
        
        return CGRect(x: w, y: h, width: w, height: h)
    }

}
