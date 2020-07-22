//
//  SkeletonAnimator.swift
//  skeleton
//
//  Created by Viktor Zinets on 25.05.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class SkeletonAnimator: NSObject {
    
    private var bgLayer: CALayer!
    private var gradientLayer: CAGradientLayer!
    
    func beginSkeletAnimation(for view: UIView) {
        bgLayer = CALayer()
        bgLayer.frame = view.bounds
        bgLayer.backgroundColor = view.backgroundColor?.cgColor
        view.layer.addSublayer(bgLayer)
        
        gradientLayer = self.makeGradient(view: view)
        gradientLayer.add(self.makeLocationsAnimaton(), forKey: nil)
        bgLayer.addSublayer(gradientLayer)
    }
    
    func stopAnimation() {
        guard bgLayer != nil,
            gradientLayer != nil else {
                return
        }
        
        let removeAnimation = CABasicAnimation(keyPath: "opacity")
        removeAnimation.duration = 2
        removeAnimation.toValue = 0
        removeAnimation.delegate = self
        
        bgLayer.add(removeAnimation, forKey: nil)
    }
    
    private func makeGradient(view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = .init(x: -0.25, y: 1)
        gradientLayer.endPoint = .init(x: 1.25, y: 0)
        gradientLayer.locations = [-0.25,-0.125, 0]
        
        gradientLayer.frame = view.bounds
//        gradientLayer.mask = self.makeSkelet(for: view)
        
        return gradientLayer
    }
    
    private func maskedViews(view: UIView) -> [UIView] {
        var views: [UIView] = []
        if view.tag == 1 {
            views.append(view)
        } else {
            view.subviews.forEach { (view) in
                views.append(contentsOf: self.maskedViews(view: view))
            }
        }
        return views
    }
    
    private func makeSkelet(for view: UIView) -> CALayer {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.fillColor = UIColor.clear.cgColor
       
        let views = self.maskedViews(view: view)
        views.forEach { (v) in
            let subPath: UIBezierPath
            let convertedFrame = v.superview!.convert(v.frame, to: view)
            switch v {
            case is UILabel:
                subPath = UIBezierPath(roundedRect: convertedFrame, cornerRadius: 7)
            case is UIButton:
                subPath = UIBezierPath(roundedRect: convertedFrame, cornerRadius: v.frame.height / 2)
            case is UIImageView:
                subPath = UIBezierPath(roundedRect: convertedFrame, cornerRadius: v.frame.height / 2)
            default:
                subPath = UIBezierPath(roundedRect: convertedFrame, cornerRadius: 16)
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

extension SkeletonAnimator: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        bgLayer.removeAllAnimations()
        bgLayer.removeFromSuperlayer()
    }
}
