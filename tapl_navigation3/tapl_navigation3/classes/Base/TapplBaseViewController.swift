//
//  TapplBaseViewController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController: UIViewController {
    
    private let cornerRadius: CGFloat = 16

    var shadowIsVisible: Bool = false {
        didSet {
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.duration = 0.15
            if self.shadowIsVisible {
                self.view.layer.shadowOpacity = 0.6
                self.view.clipsToBounds = false
            } else {
                self.view.layer.shadowOpacity = 0.0
                self.view.clipsToBounds = true
            }
            self.view.layer.add(animation, forKey: "shadow")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = cornerRadius
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.0
        self.view.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.view.layer.shadowColor = UIColor.red.cgColor
        
        self.shadowIsVisible = true
    }
    


}
