//
//  ProfileButtonsPanel.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileButtonsPanel: UIView {

    let maskLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.mask = maskLayer
        
        applyShape()
    }
    
    private func applyShape() {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: bounds.size.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height * 0.65))
        
        path.close()
        
        maskLayer.path = path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShape()
    }

}
