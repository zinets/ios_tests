//
//  TapplBaseView.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseView: UIView {

    static let cornerRadius: CGFloat = 50
    var handleView: UIView!
    
    private var inited = false // механика подмены супервью при добавлении должна работать после добавления content view

    override class var layerClass: AnyClass {
        return TapplBaseViewLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func addHandle () {
        handleView = UIView()
        handleView.translatesAutoresizingMaskIntoConstraints = false
        handleView.backgroundColor = UIColor.clear
        handleView.isHidden = true
        
        self.addSubview(handleView)
        // модно, стильно, молодежно!
        NSLayoutConstraint.activate([
            handleView.widthAnchor.constraint(equalToConstant: 200),
            handleView.heightAnchor.constraint(equalToConstant: 3 * 4),
            handleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            handleView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
        ])
//        handleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        handleView.heightAnchor.constraint(equalToConstant: 3 * 4).isActive = true
//        handleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        handleView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        let grayView = UIView()
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        grayView.layer.cornerRadius = 2
        
        handleView.addSubview(grayView)
        NSLayoutConstraint.activate([
            grayView.widthAnchor.constraint(equalToConstant: 46),
            grayView.heightAnchor.constraint(equalToConstant: 4),
            grayView.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            grayView.centerYAnchor.constraint(equalTo: handleView.centerYAnchor),
        ])
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
        addHandle()
        inited = true
    }
    
    // content site
    private let contentView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // iOS 11+ !!
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = TapplBaseView.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    // если каким-то образом в рунтайме будут добавляться вью, то их нужно добавлять на всю контента - авось это сработает
    // #warning особо не тестировалось.. от слова "вообще"
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
    
    /// делаем имидж из того, что есть
    var underlayingViewImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.masksToBounds = false
        
        shadowLayer.shadowRadius = 3
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowOffset = CGSize(width: 0, height: -4)
        shadowLayer.shadowColor = UIColor(rgb: 0xeeece8).cgColor
        self.addSublayer(shadowLayer)
        
        clipLayer.masksToBounds = true
        clipLayer.fillColor = UIColor.white.cgColor
        shadowLayer.addSublayer(clipLayer)
    }
    
    override var bounds: CGRect {
        didSet {
            if !bounds.isEmpty {
                let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: TapplBaseView.cornerRadius, height: TapplBaseView.cornerRadius))
                
                clipLayer.frame = bounds
                clipLayer.path = path.cgPath
                
                shadowLayer.frame = bounds                
            }
        }
    }
    
}
