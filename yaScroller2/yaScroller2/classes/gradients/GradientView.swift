//
//  GradientView.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/29/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class GradientView: UIView {

    lazy var bgLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(rgb: 0xfec624).cgColor,
            UIColor(rgb: 0xf161f8).cgColor,
            UIColor(rgb: 0x7b2df8).cgColor,
        ]
        layer.startPoint = CGPoint(x: 1.0, y: 0.3)
        layer.endPoint = CGPoint(x: 0.0, y: 0.7)
        layer.frame = self.bounds
        layer.shouldRasterize = true
        
        layer.mask = self.maskLayer
        
        return layer
    }()
    
    lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        let path = UIBezierPath(ovalIn: layer.bounds)
        
        layer.path = path.cgPath
        
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(bgLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        if let animation = layer.animation(forKey: "position") {
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
        } else {
            CATransaction.disableActions()
        }
        
        bgLayer.frame = self.bounds
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        let newPath = UIBezierPath(ovalIn: bgLayer.bounds)
        pathAnimation.fromValue = maskLayer.path
        pathAnimation.toValue = newPath.cgPath
        
        maskLayer.add(pathAnimation, forKey: "path")
        maskLayer.path = newPath.cgPath
        
        CATransaction.commit()
    }
}
