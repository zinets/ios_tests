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
            let animation = CABasicAnimation(keyPath: "colors")
            animation.fromValue = colors
            var newColors = [CGColor]()
            
            for color in newValue {
                newColors.append(color.cgColor)
            }
            
            animation.toValue = newColors
            animation.duration = 5
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            
            self.gradientLayer.add(animation, forKey: "colors")
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
