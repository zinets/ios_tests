//
//  TapplActivitiesSegmentedControl.swift
//  activitiesProto
//
//  Created by Victor Zinets on 1/16/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class TapplActivitiesSegmentedControl: UISegmentedControl {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.commonInit()
//    }
//    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private let borderColor = UIColor(rgb: 0xededec)
    private let inactiveTextColor = UIColor(rgb: 0x999999)
    private let activeTextColor = UIColor.black
    private let textFont = UIFont.systemFont(ofSize: 13, weight: .bold)
    
    private func commonInit() {
        self.backgroundColor = .white
        self.tintColor = .white
        
        self.layer.cornerRadius = 1
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        
        
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: inactiveTextColor,
            NSAttributedString.Key.font: textFont
        ], for: .normal)
        
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: activeTextColor,
            NSAttributedString.Key.font: textFont
            ], for: .selected)
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(borderColor.cgColor)
            context.fill(rect);
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                self.setDividerImage(image, forLeftSegmentState: UIControl.State.normal, rightSegmentState: UIControl.State.normal, barMetrics: UIBarMetrics.default)
            }
            
            UIGraphicsEndImageContext();
        }
    }

}
