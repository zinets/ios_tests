//
//  TapplBaseView.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

extension UIView {
    
    func prepareView () {
        UIApplication.shared.keyWindow?.backgroundColor = self.backgroundColor
        self.backgroundColor = .white
        
        // TODO: это херня, т.к. скругление будет и снизу
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 1
        
//        self.layer.shadowColor = UIColor(rgb: 0xeeece8).cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize(width: 0, height: -4)
//
//        self.clipsToBounds = false
//        self.layer.masksToBounds = false
        
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//
//        self.layer.mask = maskLayer
    }
}

