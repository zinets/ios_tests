//
//  ProgressWithGradient2.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/29/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProgressWithGradient2: GradientView, ProgressControl {
    // толщина линии прогресса
    let progressLineWidth: CGFloat = 10
    // доп. пространство для текстовочек
    let additionalSpace: CGFloat = 15
    
    class TextLayer {
        var text: String
        // позиция на круге, 0..1
        var pos: CGFloat
        var layer: CATextLayer?
        
        init(text: String, pos: CGFloat) {
            self.text = text
            self.pos = pos
        }
    }
    
    let textLayers = [
        TextLayer(text: "Nice", pos: 0.3),
        TextLayer(text: "Cool", pos: 0.6),
        TextLayer(text: "Wow!", pos: 0.9),
    ]
    
    var progressLayer: CAShapeLayer?
    
    lazy var maskLayer: CALayer = {
        let composedMaskLayer = CALayer()
        composedMaskLayer.frame = self.bounds
        
        // слой с линией прогресса
        let layer = CAShapeLayer()
        
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = progressLineWidth
        layer.lineCap = kCALineCapRound
        
        layer.strokeEnd = 1
        
        var angle: CGFloat = .pi / 2
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DScale(transform, -1, 1, 1)
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        layer.transform = transform
        //
        progressLayer = layer
        composedMaskLayer.addSublayer(progressLayer!)
        
        // слой(и) с текстами
        for textLayer in textLayers {
            let sublayer2 = CATextLayer()
            
            let textString: String = textLayer.text
            // TODO: setup font..
            sublayer2.fontSize = 10
            let font = UIFont.boldSystemFont(ofSize: sublayer2.fontSize)
            sublayer2.font = font
            sublayer2.foregroundColor = UIColor.gray.cgColor
            
            let textSize = textString.sizeWithConstrainedWidth(width: self.bounds.size.width, font: font)
            sublayer2.string = textString
            
            let x = (self.bounds.size.width - textSize.width) / 2
            let y = (self.bounds.size.height - textSize.height) / 2
            
            sublayer2.frame = CGRect(origin: CGPoint(x: x, y: y), size: textSize)
            
            sublayer2.alignmentMode = kCAAlignmentCenter
            sublayer2.contentsScale = UIScreen.main.scale
            
            // мажик
            angle = 2 * .pi - textLayer.pos * 2 * .pi + .pi / 2
            
            transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, angle, 0, 0, 1)
            let offset = (self.bounds.size.height - additionalSpace) / 2
            transform = CATransform3DTranslate(transform, offset, 0, 0)
            transform = CATransform3DRotate(transform, .pi / 2 * (angle < .pi ? -1 : 1), 0, 0, 1)
            
            sublayer2.transform = transform
            //
            textLayer.layer = sublayer2
            
            composedMaskLayer.addSublayer(sublayer2)
        }
        
        return composedMaskLayer
    }()
    
    override func commonInit() {
        super.commonInit()
        gradientLayer.mask = maskLayer
        
        self.backgroundColor = UIColor.white
    }

    // MARK: protocol -
    
    var position: CGFloat = 0 {
        didSet {
            let pos = max(0, min(1, position))
            progressLayer!.strokeEnd = pos
            
            for textLayer in textLayers {
                if let layer = textLayer.layer {
                    if textLayer.pos > pos {
                        // make gray
                        self.layer.addSublayer(layer)
                    } else {
                        // use as mask
                        self.maskLayer.addSublayer(layer)
                    }
                }
            }
        }
    }
    
    // MARK: animation -
    
    override func changesToAnimate() {
        gradientLayer.frame = self.bounds
        maskLayer.frame = self.bounds
        
        if let layer1 = progressLayer {
            let pathAnimation = CABasicAnimation(keyPath: "path")
            let offset = additionalSpace + progressLineWidth / 2
            let newPath = UIBezierPath(ovalIn: maskLayer.bounds.insetBy(dx: offset, dy: offset))
            pathAnimation.fromValue = layer1.path
            pathAnimation.toValue = newPath.cgPath
            
            layer1.add(pathAnimation, forKey: "path")
            layer1.path = newPath.cgPath
        }
        
        for textLayer in textLayers {
            let sublayer2 = textLayer.layer!
            sublayer2.removeAllAnimations()
            
            // мажик - кручу-верчу, запутать хочу; у слоя угол вращения начинается на 15 часов; но по дизу начинать надо из 18 часов; кроме того, направление прогресса против часовой стрелки - отобразим эти факты в выражении
            let angle = (2 * .pi - textLayer.pos * 2 * .pi) + .pi / 2
            
            sublayer2.transform = CATransform3DIdentity
            let textSize = sublayer2.frame.size
            
            let x = (self.bounds.size.width - textSize.width) / 2
            let y = (self.bounds.size.height - textSize.height) / 2
            
            sublayer2.frame = CGRect(origin: CGPoint(x: x, y: y), size: textSize)
            
            var transform = sublayer2.transform
            transform = CATransform3DRotate(transform, angle, 0, 0, 1)
            let offset = (self.bounds.size.height - additionalSpace) / 2
            transform = CATransform3DTranslate(transform, offset, 0, 0)
            transform = CATransform3DRotate(transform, .pi / 2 * (angle < .pi ? -1 : 1), 0, 0, 1)
            
            sublayer2.transform = transform
        }
    }
}
