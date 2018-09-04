//
//  ProfileOnlineIndicatorView.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileOnlineIndicatorView: UIView {

    enum OnlineState {
        case Online, Recently, Offline
    }
    
    private let onlineColor = UIColor(rgb: 0x1ab136)
    private let recentColor = UIColor(rgb: 0x7c30fe)
    private let offlineColor = UIColor(rgb: 0xd8d8d8)

    var state: OnlineState = .Offline {
        didSet {
            switch state {
            case .Online:
                self.backgroundColor = onlineColor
            case .Recently:
                self.backgroundColor = recentColor
            case .Offline:
                self.backgroundColor = offlineColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        layer.mask = maskLayer
    }
}
