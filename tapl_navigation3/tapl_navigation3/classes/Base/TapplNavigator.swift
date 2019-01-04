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
    
    // MARK: - navbar
    @IBOutlet private weak var tabbarTop: NSLayoutConstraint!
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
    
    private var _tabBarController: TapplTabbarController!
    override var tabBarController: UITabBarController? {
        get {
            return _tabBarController
        }
    }
    
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var messagesButton: UIButton!
    @IBOutlet private weak var activitiesButton: UIButton!
    
    @IBOutlet private weak var messagesCounterLabel: UILabel!
    @IBOutlet private weak var messagesCounterSite: UIView!
    var messagesCount: Int = 0 {
        didSet {
            messagesCounterLabel.text = self.counterText(messagesCount)
            messagesCounterSite.isHidden = messagesCount == 0
            self.makeZdrizhEffect(messagesCounterSite)
        }
    }
    @IBOutlet private weak var activitiesCounterLabel: UILabel!
    @IBOutlet private weak var activitiesCounterSite: UIView!
    var activitiesCount: Int = 0 {
        didSet {
            activitiesCounterLabel.text = self.counterText(activitiesCount)
            activitiesCounterSite.isHidden = activitiesCount == 0
            self.makeZdrizhEffect(activitiesCounterSite)
        }
    }
    
    private func makeZdrizhEffect(_ view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0.0,
                       options: [.curveEaseOut], animations: {
            view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (_) in
            view.transform = .identity
        }
    }
    
    private func counterText(_ value: Int) -> String {
        return value < 11 ? String(value) : "10+"
    }
    
    @IBAction func testTap(_ sender: Any) {
        self.activitiesCount += 1
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // я хз, хак конем :)
        myCtrl = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let tabbarCtrl = segue.destination as? TapplTabbarController {
            _tabBarController = tabbarCtrl
        }
    }
    
    // MARK: - navigation
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
    
    // MARK: - appearance
    
    private func bgColor() -> UIColor {
        return isNavbarVisible ? TapplMagic.mainBackgroundColor : TapplMagic.darkBackgroundColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return self.isNavbarVisible ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
        }
    }
 
}

