//
//  TapplBaseView.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseView: UIView {
    
    private var inited = false // механика подмены супервью при добавлении должна работать после добавления content view
    override class var layerClass: AnyClass {
        return TapplBaseViewLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
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
        inited = true
    }
    
    // content site
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
    
    // если каким-то образом в рунтайме будут добавляться вью, то их нужно добавлять на всю контента - авось это сработает
    override func addSubview(_ view: UIView) {
        guard inited, view != contentView else {
            super.addSubview(view)
            return
        }
        contentView.addSubview(view)
    }
    
    override func insertSubview(_ view: UIView, at index: Int) {
        guard inited, view != contentView else {
            super.addSubview(view)
            return
        }
        contentView.insertSubview(view, at: index)
    }
    
    override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        guard inited, view != contentView else {
            super.addSubview(view)
            return
        }
        contentView.insertSubview(view, aboveSubview: siblingSubview)
    }
    
    override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        guard inited, view != contentView else {
            super.addSubview(view)
            return
        }
        contentView.insertSubview(view, belowSubview: siblingSubview)
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
