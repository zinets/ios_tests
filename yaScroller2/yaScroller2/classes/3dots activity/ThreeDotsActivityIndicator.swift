//
//  ThreeDotsActivityIndicator.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ThreeDotsActivityIndicator: UIView {

    var dotsCount: Int = 3
    var dotSize = CGSize(width: 4, height: 4)
    var dotSpace: CGFloat = 3.0
    
    var activeDotColor = UIColor.white //(rgb: 0x9C9A9D)
    var dotColor = UIColor(rgb: 0x9C9A9D)
    
    let dotLayer = CAShapeLayer()
    
    let animationDuration: TimeInterval = 1.7
    
    func commonInit() {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = dotsCount;
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(dotSize.width + dotSpace, 0, 0)
        replicatorLayer.instanceDelay = animationDuration / Double(dotsCount)
        
        dotLayer.frame = CGRect(origin: CGPoint.zero, size: dotSize)
        dotLayer.fillColor = dotColor.cgColor
        dotLayer.path = UIBezierPath(ovalIn: dotLayer.bounds).cgPath
        
        replicatorLayer.addSublayer(dotLayer)
        layer.addSublayer(replicatorLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func startAnimation() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = self.animationDuration
        groupAnimation.repeatCount = HUGE
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let times:[NSNumber] = [0, 0.2, 0.4, 1]
        let keyframeAnimation1 = CAKeyframeAnimation(keyPath: "transform.scale")
        keyframeAnimation1.duration = groupAnimation.duration
        keyframeAnimation1.keyTimes = times
        keyframeAnimation1.values =   [1, 1.5, 1, 1]
        groupAnimation.animations = [keyframeAnimation1]
        
        if (dotColor != activeDotColor) {
            let keyframeAnimation2 = CAKeyframeAnimation(keyPath: "fillColor")
            keyframeAnimation2.duration = groupAnimation.duration
            keyframeAnimation2.keyTimes = times
            keyframeAnimation2.values = [dotColor.cgColor, activeDotColor.cgColor, dotColor.cgColor, dotColor.cgColor]
            
            groupAnimation.animations?.append(keyframeAnimation2)
        }
        dotLayer.add(groupAnimation, forKey: "pulsing")
    }
    
    func stopAnimation() {
        dotLayer.removeAllAnimations()
    }

}
