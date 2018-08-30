//
//  GradientView.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/29/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

// просто вью, фон которого - градиент
// + анимация изменения фрейма

class GradientView: UIView {

    /// массив цветов для формирования градиента; распределение равномерное
    var gradientColors: [UIColor] = [] {
        didSet {
            var cgColors = [CGColor]()
            for color in gradientColors {
                cgColors.append(color.cgColor)
            }
            gradientLayer.colors = cgColors
        }
    }
    
    let defaultColors =  [
        UIColor(rgb: 0xfec624),
        UIColor(rgb: 0xf161f8),
        UIColor(rgb: 0x7b2df8)
    ]
    
    /// угол градиента, от 0 до 1; 0 == 12 часов
    var gradientAngle: CGFloat = 0 {
        didSet {
            let angle = 2 * .pi * CGFloat(gradientAngle) - .pi / 2
            var x: CGFloat = 0.5 + cos(angle) / 2
            var y: CGFloat = 0.5 + sin(angle) / 2
            gradientLayer.startPoint = CGPoint(x: x, y: y)
            
            x = 0.5 + cos(angle + .pi) / 2
            y = 0.5 + sin(angle + .pi) / 2
            gradientLayer.endPoint = CGPoint(x: x, y: y)
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 1.0, y: 0.5)
        layer.endPoint = CGPoint(x: 0.0, y: 0.5)
        layer.frame = self.bounds
        layer.shouldRasterize = true
        
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
        self.layer.addSublayer(gradientLayer)
        self.gradientColors = defaultColors
        self.gradientAngle = 0;
    }
    
    func changesToAnimate() {
        gradientLayer.frame = self.bounds
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
        
        changesToAnimate()
        CATransaction.commit()
    }
}
