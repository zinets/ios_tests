//
//  ProgressWithGradient.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/29/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

protocol ProgressControl {
    var progressValue: CGFloat { get set }
}

class ProgressWithGradient: GradientView, ProgressControl {
    let progressLineWidth: CGFloat = 10
    lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = progressLineWidth
        layer.lineCap = kCALineCapRound
        
        let angle: CGFloat = .pi / 2
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DScale(transform, -1, 1, 1)
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        layer.transform = transform
        
        return layer
    }()
    
    override func commonInit() {
        super.commonInit()
        gradientLayer.mask = maskLayer
        
        progressValue = 0
    }
    
    // MARK: setters -
    
    var progressValue: CGFloat = 0 {
        didSet {
            // TODO: анимация заполнения новым значением - если недостаточно implicitа
            maskLayer.actions = ["strokeEnd": NSNull()]            
            maskLayer.strokeEnd = max(0, min(1, progressValue))
        }
    }
    
    // MARK: animation -
    
    override func changesToAnimate() {
        gradientLayer.frame = self.bounds
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        let newPath = UIBezierPath(ovalIn: self.bounds.insetBy(dx: progressLineWidth / 2, dy: progressLineWidth / 2))
        pathAnimation.fromValue = maskLayer.path
        pathAnimation.toValue = newPath.cgPath
        
        maskLayer.add(pathAnimation, forKey: "path")
        maskLayer.path = newPath.cgPath
    }
    
}
