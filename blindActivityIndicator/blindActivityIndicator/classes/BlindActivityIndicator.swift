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

@IBDesignable
class BlindActivityIndicator: UIView {

    var activeColors   = [ UIColor(rgb: 0xe95871).cgColor, UIColor(rgb: 0xf98252).cgColor ]
    var inactiveColors = [ UIColor(rgb: 0x525A68).cgColor, UIColor(rgb: 0x525A68).cgColor ]
    var updateTime: TimeInterval = 3.5 // время за которое точка обойдет круг
    
    @IBInspectable
    var numberOfDots: Int = 7 {
        didSet {
            _updateReplicator()
            _update()
        }
    }
    
    @IBInspectable /// радиус (!) точки
    var dotRadius: CGFloat = 8 {
        didSet {
            dotLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 2 * dotRadius, height: 2 * dotRadius))
            dotLayer.cornerRadius = dotRadius;
            _update()
        }
    }
    
    @IBInspectable /// расстояние от центра контрола до центра каждой точки; т.е. до края контрола надо еще учитывать радиус точки
    var radius: CGFloat = 25 {
        didSet {
            _update()
        }
    }
    
    private func _update() {
        let w = (radius + dotRadius) * 2
        replicantLayer.frame.size = CGSize(width: w, height: w)
        dotLayer.position = CGPoint(x: w / 2 + radius, y: w / 2)
        
        self.invalidateIntrinsicContentSize()
    }
    
    lazy private var dotLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 2 * dotRadius, height: 2 * dotRadius))
        layer.cornerRadius = dotRadius;
        layer.colors = inactiveColors
        
        return layer
    }()
    
    private func _updateReplicator() {
        replicantLayer.instanceCount = numberOfDots
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, 2 * CGFloat.pi / CGFloat(numberOfDots), 0, 0, 1)
        replicantLayer.instanceTransform = transform
        
        replicantLayer.instanceDelay = updateTime / Double(numberOfDots)
    }
    
    lazy private var replicantLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        let w = (radius + dotRadius) * 2
        layer.frame.size = CGSize(width: w, height: w)
        
        dotLayer.position = CGPoint(x: w / 2 + radius + dotRadius, y: w / 2)
        layer.addSublayer(dotLayer)
        
        layer.instanceCount = numberOfDots
        
        var transform = CATransform3DIdentity
//        transform = CATransform3DTranslate(transform, radius, 0, 0) // дублирование элементов по кругу делается не сдвигом и поворотом - хотя так тоже можно, но траектория непредсказуемая в смысле боундса контрола, а начальным расположением элемента со сдвигом относительно центра и поворотами
        transform = CATransform3DRotate(transform, 2 * CGFloat.pi / CGFloat(numberOfDots), 0, 0, 1)
        layer.instanceTransform = transform
        
        layer.instanceDelay = updateTime / Double(numberOfDots)
        
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.red.cgColor
        
        return layer
    }()
    
    private func commonInit() {
        self.layer.addSublayer(replicantLayer)
        
        _update()
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.white.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.replicantLayer.position = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    // MARK: actions -
    func startAnimation() {
        guard self.dotLayer.animationKeys() == nil else { return }
        
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
    
    override var intrinsicContentSize: CGSize {
        let w = (radius + dotRadius) * 2
        let sz = CGSize(width: w, height: w)

        return sz
    }
    
//    override func prepareForInterfaceBuilder() {
//    почему закоментировано; что если этот метод перегружен, то в ибилдере можно менять inspectable свойства, но визуально они там не меняются и всегда будут использоваться заданные в этом методе значения
//        self.dotRadius = 8
//        self.radius = 50
//    }
}
