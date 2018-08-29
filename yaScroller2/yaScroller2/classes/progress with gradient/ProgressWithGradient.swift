//
//  ProgressWithGradient.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/29/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProgressWithGradient: UIView {
    
    var bgLayer: CAGradientLayer?
    func createBgLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(rgb: 0xfec624).cgColor,
            UIColor(rgb: 0xf161f8).cgColor,
            UIColor(rgb: 0x7b2df8).cgColor,
        ]
        layer.startPoint = CGPoint(x: 1.0, y: 0.5)
        layer.endPoint = CGPoint(x: 0.0, y: 0.5)
        layer.frame = self.bounds
        layer.shouldRasterize = true
        
        maskLayer = createMaskLayer()
        layer.mask = maskLayer!
        
        return layer
    }
    
    var maskLayer: CAShapeLayer?
    func createMaskLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = self.bounds.insetBy(dx: 5, dy: 5)
        let path = UIBezierPath(ovalIn: layer.bounds)
        
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 10
        layer.lineCap = kCALineCapRound
        
        let angle: CGFloat = .pi / 2
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DScale(transform, -1, 1, 1)
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        layer.transform = transform
        
        return layer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.green
        bgLayer = createBgLayer()
        self.layer.addSublayer(bgLayer!)
        position = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgLayer?.frame = self.bounds
        maskLayer?.frame = self.bounds
        maskLayer?.path = UIBezierPath(ovalIn: self.bounds.insetBy(dx: 5, dy: 5)).cgPath
    }
    
    // MARK: setters -
    
    var position: CGFloat = 0 {
        didSet {
            if let layer = maskLayer {
                layer.strokeEnd = max(0, min(1, position))
            }
        }
    }
    
}
