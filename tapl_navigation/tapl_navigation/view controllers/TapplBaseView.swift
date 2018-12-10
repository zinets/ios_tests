//
//  TapplBaseView.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

extension UIView {
//    let const underliedViewTag = 73465
    func removeUnderliedView () {
        if let view = self.viewWithTag(73465) {
            view.alpha = 0
            view.removeFromSuperview()
        }
    }
    
    func prepareView () {
        UIApplication.shared.keyWindow?.backgroundColor = self.backgroundColor
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 15
        
        self.layer.shadowColor = UIColor(rgb: 0xeeece8).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: -4)
        
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//
//        self.layer.mask = maskLayer
    }
}

class TapplBaseViewLayer : CALayer {
    
    override init() {
        super.init()
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        commonInit()
    }
    
    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        // TODO: hardcoded color of "shaped" layer
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.red.cgColor
        
//        layer.shadowColor = UIColor.red.cgColor
//        layer.shadowRadius = 12
//        layer.shadowOffset = CGSize(width: 0, height: -4)
//        layer.shadowOpacity = 1
        
        return layer
    }()
    
    private func layerPath () -> UIBezierPath {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        return path
    }
    
    private func commonInit() {
        // TODO: hardcoded color of underlied layer
        backgroundColor = UIColor(rgb: 0xf9f8f6).cgColor
        addSublayer(self.shapeLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        // TODO: анимация изменения фрейма слоя - а то херово-херово
        self.shapeLayer.frame = self.bounds
        let path: UIBezierPath = layerPath()
        self.shapeLayer.path = path.cgPath
    }
}
