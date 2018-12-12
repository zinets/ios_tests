//
//  TapplBaseView.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseView: UIView {
    
    override class var layerClass: AnyClass {
        return TapplBaseViewLayer.self
    }

}

class TapplBaseViewLayer: CAShapeLayer {
    
    override init() {
        super.init()
        commonInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {        
        self.shadowOpacity = 1
        self.shadowColor = UIColor.red.cgColor
        self.shadowRadius = 4
        self.shadowOffset = CGSize(width: 0, height: -4)
        
        self.fillColor = UIColor.darkGray.cgColor
    }
    
    override var bounds: CGRect {
        didSet {
            if !bounds.isEmpty {
                let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 50, height: 50))
                self.path = path.cgPath
            }
        }
    }
}
