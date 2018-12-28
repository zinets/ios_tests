//
//  TapplBaseViewController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController: UIViewController {
    
    // призрак предыдущего контроллера
    var shadowedView: UIView? {
        willSet {
            if let view = shadowedView {
                view.removeFromSuperview()
            }
        }
    }
    // тень вокруг окна, нужна только для "корневого" контроллера
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
    
    private func setupAppearance() {
        self.view.layer.cornerRadius = TapplMagic.viewControllerCornerRadius
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.0
        self.view.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.view.layer.shadowColor = TapplMagic.controllerShadowColor.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
        
        self.shadowIsVisible = true
    }
    
    @IBAction func backAction(_ sender: Any) {
       myCtrl.popController(self)
    }
    
    @IBAction func push(_ sender: Any) {
        if let ctrl = UIStoryboard(name: "TapplSearch", bundle: nil).instantiateViewController(withIdentifier: "WhiteCtrl") as? TapplBaseViewController {
            myCtrl.pushController(ctrl, navController: self.navigationController!)
        }
    }
    
    
}
