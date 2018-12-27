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
    
    private var isNavbarVisible: Bool = true {
        didSet {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: TapplMagic.navigationAnimationDuration) {
                self.navbarHeight.constant = self.isNavbarVisible ? 52 : 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myCtrl = self
    }
    
    func pushController(_ ctrl: UIViewController, navController: UINavigationController) {
        isNavbarVisible = false
        navController.pushViewController(ctrl, animated: true)
        
        UIView.animate(withDuration: TapplMagic.navigationAnimationDuration) {
            self.view.backgroundColor = TapplMagic.mainBackgroundColor2
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func popController(_ ctrl: UIViewController) {
        ctrl.navigationController?.popViewController(animated: true)
        isNavbarVisible = ctrl.navigationController?.viewControllers.count == 1
        UIView.animate(withDuration: TapplMagic.navigationAnimationDuration) {
            self.view.backgroundColor = TapplMagic.mainBackgroundColor
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return self.isNavbarVisible ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}
