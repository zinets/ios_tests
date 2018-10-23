//
//  AnimatedGradientPanel.swift
//  testGradients
//
//  Created by Zinets Victor on 10/22/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

import UIKit

class AnimatedGradientPanel: UIView {

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.drawsAsynchronously = true
        for color in self.colors {
            if let _ = layer.colors {
                layer.colors!.append(color.cgColor)
            } else {
                layer.colors = [color.cgColor]
            }
        }
        
        return layer
    }()
    
    var colors: [UIColor] {
        willSet {
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 5
            animationGroup.isRemovedOnCompletion = false
            animationGroup.fillMode = kCAFillModeForwards
            
            let animation1 = CABasicAnimation(keyPath: "colors")
            animation1.duration = animationGroup.duration

            var newColors = [CGColor]()
            for color in newValue {
                newColors.append(color.cgColor)
            }
            animation1.toValue = newColors

//            animation1.isRemovedOnCompletion = false
//            animation1.fillMode = kCAFillModeForwards
            
            let animation2 = CABasicAnimation(keyPath: "startPoint")
            animation2.duration = animationGroup.duration
            animation2.toValue = CGPoint(x: CGFloat.random(in: 0...1), y: 0)
//            animation2.isRemovedOnCompletion = false
//            animation2.fillMode = kCAFillModeForwards
            
            let animation3 = CABasicAnimation(keyPath: "endPoint")
            animation3.duration = animationGroup.duration
            animation3.toValue = CGPoint(x: CGFloat.random(in: 0...1), y: 1)
//            animation3.isRemovedOnCompletion = false
//            animation3.fillMode = kCAFillModeForwards
            
            animationGroup.animations = [animation1, animation2, animation3]
            
            self.gradientLayer.add(animationGroup, forKey: "gradientAnimation")
        }
    }
    
    private let defaultColors = [
        UIColor.red, UIColor.green, UIColor.blue
    ]
    
    override init(frame: CGRect) {
        colors = defaultColors
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        colors = defaultColors
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.layer.addSublayer(self.gradientLayer)
        
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientLayer.frame = self.bounds
    }

}
