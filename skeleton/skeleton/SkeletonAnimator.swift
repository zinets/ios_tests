//
//  SkeletonAnimator.swift
//  skeleton
//
//  Created by Viktor Zinets on 25.05.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class SkeletonAnimator {
    
    private var bgLayer: CALayer!
    private var gradientLayer: CAGradientLayer!
    
    func beginSkeletAnimation(for view: UIView) {
        bgLayer = CALayer()
        bgLayer.frame = view.bounds
        bgLayer.backgroundColor = view.backgroundColor?.cgColor
        view.layer.addSublayer(bgLayer)
        
        gradientLayer = self.makeGradient(view: view)
        gradientLayer.add(self.makeLocationsAnimaton(), forKey: nil)
        view.layer.addSublayer(gradientLayer)
    }
    
    private func makeGradient(view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = .init(x: -0.25, y: 0)
        gradientLayer.endPoint = .init(x: 1.25, y: 1)
        gradientLayer.locations = [-0.25,-0.125, 0]
        
        gradientLayer.frame = view.bounds
        gradientLayer.mask = self.makeSkelet(for: view)
        
        return gradientLayer
    }
    
    private func makeSkelet(for view: UIView) -> CALayer {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.fillColor = UIColor.clear.cgColor
       
        view.subviews.forEach { (view) in
            let subPath: UIBezierPath
            switch view {
            case is UILabel:
                subPath = UIBezierPath(roundedRect: view.frame, cornerRadius: 7)
            case is UIButton:
                subPath = UIBezierPath(roundedRect: view.frame, cornerRadius: view.frame.height / 2)
            case is UIImageView:
                subPath = UIBezierPath(roundedRect: view.frame, cornerRadius: view.frame.height / 2)
            default:
                subPath = UIBezierPath(roundedRect: view.frame, cornerRadius: 16)
            }
            let layer = CAShapeLayer()
            layer.path = subPath.cgPath
            maskLayer.addSublayer(layer)
        }
        
        return maskLayer
    }
    
    private func makeLocationsAnimaton() -> CABasicAnimation {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.duration = 5
        gradientAnimation.fromValue = [-0.15, -0.025, 0.1]
        gradientAnimation.toValue = [0.9, 1.025, 1.15]
        gradientAnimation.autoreverses = false
        gradientAnimation.repeatCount = Float.infinity
        
        return gradientAnimation
    }
}
