//
//  BlindActivityIndicator.swift
//  blindActivityIndicator
//
//  Created by Victor Zinets on 11/6/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class BlindActivityIndicator: UIView {

    let radius: CGFloat = 35
    let numberOfDots: Int = 7
    let updateTime: TimeInterval = 3.5 // время за которое точка обойдет круг
    
    let activeColors = [ UIColor(rgb: 0xe95871).cgColor, UIColor(rgb: 0xf98252).cgColor ]
    let inactiveColors = [ UIColor(rgb: 0x525A68).cgColor, UIColor(rgb: 0x525A68).cgColor ]
    
    lazy private var dotLayer: CAGradientLayer = {
        
        let dotRadius: CGFloat = 16
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: dotRadius, height: dotRadius))
        layer.cornerRadius = dotRadius / 2;
        layer.colors = inactiveColors
        
        return layer
    }()
    
    private func commonInit() {
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(dotLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: actions -
    func startAnimation() {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = updateTime;
        animationGroup.repeatCount = .infinity
        
        let easeOut = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        let colorAnimation = CAKeyframeAnimation(keyPath: "colors")
        colorAnimation.keyTimes = [ 0, 0.25, 0.75, 1 ]
        colorAnimation.values = [ inactiveColors, activeColors, activeColors, inactiveColors ]
        colorAnimation.duration = updateTime / Double(numberOfDots)
        colorAnimation.timingFunction = easeOut
        
        animationGroup.animations = [colorAnimation]
        
        self.dotLayer.add(animationGroup, forKey: "q")
    }
    
    func stopAnimation() {
        self.dotLayer.removeAllAnimations()
    }
}
