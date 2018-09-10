//
//  OneWayPageControl.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

open class OneWayPageControl: UIView, PageControlProtocol {
    
    /// пусть размер всегда квадратный
    public var dotSize: CGFloat = 6 {
        didSet {
            updateProperties()
        }
    }
    public let dotLineWidth: CGFloat = 1
    public let activeDotLineWidth: CGFloat = 3
    
    /// расстояние между точками
    public var dotSpace: CGFloat = 6 {
        didSet {
            updateProperties()
        }
    }
    /// у неактивных точек одинаковый цвет, но есть отличия
    @IBInspectable public var dotColor: UIColor = .green {
        didSet {
            updateProperties()
        }
    }
    @IBInspectable public var activeDotColor: UIColor = .magenta {
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
    
    private let leftDotLayer = CAShapeLayer()
    private let leftReplicatorLayer = CAReplicatorLayer()
    private let rightDotLayer = CAShapeLayer()
    private let rightReplicatorLayer = CAReplicatorLayer()
    private let activeDotLayer = CAShapeLayer()
    
    private func commonInit() {
        updateProperties()
        
        leftReplicatorLayer.addSublayer(leftDotLayer)
        self.layer.addSublayer(leftReplicatorLayer)
        
        rightReplicatorLayer.addSublayer(rightDotLayer)
        self.layer.addSublayer(rightReplicatorLayer)
        
        self.layer.addSublayer(activeDotLayer)
    }
    
    // MARK: proto -
    
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

    // MARK: layout -
    
    private func updateProperties() {
        activeDotLayer.isHidden = numberOfPages == 0
        leftReplicatorLayer.isHidden = numberOfPages == 0 || pageIndex == 0
        rightReplicatorLayer.isHidden = numberOfPages == 0 || numberOfPages - pageIndex - 1 == 0
        
        guard numberOfPages > 0 else {
            return
        }

        let addedOffset = dotLineWidth / 2
        leftDotLayer.frame = CGRect(origin: CGPoint(x: addedOffset, y: addedOffset),
                                    size: CGSize(width: dotSize - dotLineWidth, height: dotSize - dotLineWidth))
        leftDotLayer.path = UIBezierPath(ovalIn: leftDotLayer.bounds).cgPath
        leftDotLayer.lineWidth = dotLineWidth
        leftDotLayer.fillColor = UIColor.clear.cgColor
        leftDotLayer.strokeColor = dotColor.cgColor

        let leftDotsCount = pageIndex
        leftReplicatorLayer.instanceCount = leftDotsCount
        leftReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(dotSize + dotSpace, 0, 0)
        
        activeDotLayer.frame = CGRect(origin: CGPoint(x: (CGFloat(leftDotsCount) * (dotSize + dotSpace)), y: 0),
                                      size: CGSize(width: dotSize, height: dotSize))
        activeDotLayer.path = UIBezierPath(ovalIn: activeDotLayer.bounds).cgPath
        activeDotLayer.fillColor = UIColor.clear.cgColor
        activeDotLayer.strokeColor = activeDotColor.cgColor
        activeDotLayer.lineWidth = activeDotLineWidth
        
        rightDotLayer.frame = CGRect(origin: CGPoint(x: (CGFloat(numberOfPages - 1) * (dotSize + dotSpace)), y: 0),
                                    size: CGSize(width: dotSize, height: dotSize))
        rightDotLayer.path = UIBezierPath(ovalIn: rightDotLayer.bounds).cgPath
        rightDotLayer.fillColor = dotColor.cgColor
        
        let rightDotsCount = numberOfPages - leftDotsCount - 1
        rightReplicatorLayer.instanceCount = rightDotsCount
        rightReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(-(dotSize + dotSpace), 0, 0)
        
        self.invalidateIntrinsicContentSize()
    }
 
    override open var intrinsicContentSize: CGSize {
        get {
            let height = dotSize
            let width = CGFloat(numberOfPages) * (dotSize + dotSpace) - dotSpace
            return CGSize(width: width, height: height)
        }
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        numberOfPages = 7
        pageIndex = 0
    }
}
