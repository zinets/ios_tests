//
//  PageControl.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

protocol PageControlProto {
    var numberOfPages: Int { get set }
    var pageIndex: Int { get set }
}

class PageControl: UIView, PageControlProto {

    var numberOfPages: Int = 3 {
        didSet {
            updateProperties()
        }
    }
    var pageIndex: Int = 0 {
        didSet {
            updateProperties()
        }
    }
    var dotSize = CGSize(width: 6, height: 6) {
        didSet {
            updateProperties()
        }
    }
    var dotSpace: CGFloat = 10.0 {
        didSet {
            updateProperties()
        }
    }
    var activeDotColor = UIColor.white
    var dotColor = UIColor.white.withAlphaComponent(0.5) {
        didSet {
            updateProperties()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private let dotLayer = CAShapeLayer()
    private let replicatorLayer = CAReplicatorLayer()
    private let activeDotLayer = CAShapeLayer()
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        updateProperties()
        
        replicatorLayer.addSublayer(dotLayer)
        layer.addSublayer(replicatorLayer)
        layer.addSublayer(activeDotLayer)
    }
    
    private func updateProperties() {
        dotLayer.frame = CGRect(origin: CGPoint.zero, size: dotSize)
        dotLayer.fillColor = dotColor.cgColor
        dotLayer.path = UIBezierPath(ovalIn: dotLayer.bounds).cgPath
        
        replicatorLayer.instanceCount = numberOfPages;
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(dotSize.width + dotSpace, 0, 0)
        
        let pos = CGFloat(pageIndex) * (dotSize.width + dotSpace) - dotSize.width / 2
        activeDotLayer.frame = CGRect(origin: CGPoint(x: pos, y: 0), size: CGSize(width: dotSize.width * 2, height: dotSize.height))
        activeDotLayer.fillColor = activeDotColor.cgColor
        activeDotLayer.path = UIBezierPath(roundedRect: activeDotLayer.bounds, cornerRadius: dotSize.height / 2).cgPath
        
        self.invalidateIntrinsicContentSize()
    }

    // MARK: layout -
    
    override var intrinsicContentSize: CGSize {
        get {
            let height = dotSize.height
            let width = CGFloat(numberOfPages) * (dotSize.width + dotSpace) - dotSpace
            return CGSize(width: width, height: height)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
}
