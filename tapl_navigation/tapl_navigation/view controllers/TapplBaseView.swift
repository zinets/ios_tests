//
//  TapplBaseView.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseView: UIView {

    override class var layerClass : AnyClass {
        return TapplBaseViewLayer.self
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
        layer.cornerRadius = 20
        layer.backgroundColor = UIColor.magenta.cgColor
        // TODO скругления только нужных углов
        return layer
    }()
    
    private func commonInit() {
        backgroundColor = UIColor.yellow.cgColor
        
        addSublayer(self.shapeLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        self.shapeLayer.frame = self.bounds
    }
}
