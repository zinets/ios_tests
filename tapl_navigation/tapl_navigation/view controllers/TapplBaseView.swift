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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private let contentView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // iOS 11+ !!
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
    
        view.backgroundColor = UIColor.gray
    
        return view
    }()
    
    private func commonInit() {
        self.backgroundColor = UIColor.clear
       
       // preparing content site
        contentView.frame = self.bounds
        self.addSubview(contentView)
        for view in self.subviews {
            if view != contentView {
                contentView.addSubview(view)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.bounds.isEmpty {
//            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 50, height: 50))
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = maskPath.cgPath
//
//            contentView.layer.mask = maskLayer
            
        }
    }

}

class TapplBaseViewLayer: CAShapeLayer {
    
    private let clipLayer = CAShapeLayer()
    private let shadowLayer = CALayer()
    
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
        self.masksToBounds = false
        
        shadowLayer.shadowRadius = 3
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowOffset = CGSize(width: 0, height: -4)
        self.addSublayer(shadowLayer)
        
        clipLayer.masksToBounds = true
        clipLayer.fillColor = UIColor.white.cgColor
        shadowLayer.addSublayer(clipLayer)
    }
    
    
    override var bounds: CGRect {
        didSet {
            if !bounds.isEmpty {
                let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 50, height: 50))
                
                clipLayer.frame = bounds
                clipLayer.path = path.cgPath
                
                shadowLayer.frame = bounds
                
            }
        }
    }
}
