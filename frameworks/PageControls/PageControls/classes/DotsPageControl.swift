//
//  DotsPageControl.swift
//  PageControls
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

open class DotsPageControl: UIView, PageControlProtocol {
    
    open var numberOfPages: Int = 0 {
        didSet {
            updateProperties()
        }
    }
    open var pageIndex: Int = 0 {
        didSet {
            updateProperties()
        }
    }
    public var dotSize = CGSize(width: 6, height: 6) {
        didSet {
            updateProperties()
        }
    }
    public var dotSpace: CGFloat = 10.0 {
        didSet {
            updateProperties()
        }
    }
    public var activeDotColor = UIColor.white
    public var dotColor = UIColor.white.withAlphaComponent(0.5) {
        didSet {
            updateProperties()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private let dotLayer = CAShapeLayer()
    private let replicatorLayer = CAReplicatorLayer()
    private let activeDotLayer = CAShapeLayer()
    
    private func commonInit() {
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
        if numberOfPages > 0 {
            activeDotLayer.isHidden = false
            replicatorLayer.isHidden = false
            
            activeDotLayer.frame = CGRect(origin: CGPoint(x: pos, y: 0), size: CGSize(width: dotSize.width * 2, height: dotSize.height))
            activeDotLayer.fillColor = activeDotColor.cgColor
            activeDotLayer.path = UIBezierPath(roundedRect: activeDotLayer.bounds, cornerRadius: dotSize.height / 2).cgPath
        } else {
            activeDotLayer.isHidden = true
            replicatorLayer.isHidden = true
        }
        self.invalidateIntrinsicContentSize()
    }
    
    // MARK: layout -
    
    override open var intrinsicContentSize: CGSize {
        get {
            let height = dotSize.height
            let width = CGFloat(numberOfPages) * (dotSize.width + dotSpace) - dotSpace
            return CGSize(width: width, height: height)
        }
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
    
    override open func prepareForInterfaceBuilder() {
        // тут задаются начальные значения для контрола, помещенного в IB
        super.prepareForInterfaceBuilder()
        
        numberOfPages = 5
        pageIndex = 0
    }
    
}
