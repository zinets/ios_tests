//
//  RoundedGradientView.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/29/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

// вью с градиентным фоном (очевидно) и скругленными углами
// + анимация изменения размера

class RoundedGradientView: GradientView {

    lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        let path = createPath()
        
        layer.path = path.cgPath
        
        return layer
    }()

    override func commonInit() {
        super.commonInit()
        gradientLayer.mask = maskLayer
    }
    
    func createPath() -> UIBezierPath {
        let path = UIBezierPath(ovalIn: gradientLayer.bounds)
        // TODO: более другое создание рамки - например с указанным радиусом или вычислением радиуса как половины меньшей стороны
        return path
    }
    
    override func changesToAnimate() {
        gradientLayer.frame = self.bounds
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        let newPath = createPath()
        pathAnimation.fromValue = maskLayer.path
        pathAnimation.toValue = newPath.cgPath
        
        maskLayer.add(pathAnimation, forKey: "path")
        maskLayer.path = newPath.cgPath
    }
    
}
