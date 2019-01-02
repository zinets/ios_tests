//
//  TapplNavigator.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

var myCtrl: TapplNavigator!

class TapplNavigator: UIViewController {
    

    @IBOutlet weak var navbarHeight: NSLayoutConstraint!
    @IBOutlet weak var tabbarTop: NSLayoutConstraint!
    @IBOutlet private weak var tabbarView: UIView!
    
    var isNavbarVisible: Bool = true {
        didSet {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: TapplMagic.navigationAnimationDuration) {
                self.tabbarTop.constant = self.isNavbarVisible ? 0 : -TapplMagic.navigationBarHeight
                self.tabbarView.alpha = self.isNavbarVisible ? 1 : 0
                self.view.backgroundColor = self.bgColor()
                self.view.layoutIfNeeded()
            }            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // я хз, хак конем :)
        myCtrl = self
    }
    
    func pushController(_ ctrl: TapplBaseViewController, navController: UINavigationController) {
        isNavbarVisible = false
        ctrl.shadowIsVisible = false
        
        navController.pushViewController(ctrl, animated: true)
        
        UIView.animate(withDuration: TapplMagic.navigationAnimationDuration) {
            self.view.backgroundColor = self.bgColor()
            self.setNeedsStatusBarAppearanceUpdate()
            
            ctrl.isHandleViewVisible = true
        }
    }
    
    func popController(_ ctrl: UIViewController) {
        ctrl.navigationController?.popViewController(animated: true)
        isNavbarVisible = ctrl.navigationController?.viewControllers.count == 1
        
        UIView.animate(withDuration: TapplMagic.navigationAnimationDuration) {
            self.view.backgroundColor = self.bgColor()
            self.setNeedsStatusBarAppearanceUpdate()
            
            if let tappleCtrl = ctrl as? TapplBaseViewController {
                tappleCtrl.isHandleViewVisible = !self.isNavbarVisible
            }
        }
    }
    
    private func bgColor() -> UIColor {
        return isNavbarVisible ? TapplMagic.mainBackgroundColor : TapplMagic.darkBackgroundColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return self.isNavbarVisible ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
        }
    }
 
}

