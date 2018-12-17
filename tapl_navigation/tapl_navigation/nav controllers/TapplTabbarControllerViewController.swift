//
//  TapplTabbarControllerViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/17/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplTabbarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        // для того чтобы таббар не просто скрылся, а и не влиял на автолаяуты, нужно в сториборде у таббара убрать галочку transfucent
        self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.bounds.size.height)
    }
    
}

// Mark: custom animation

extension TapplTabbarControllerViewController: UITabBarControllerDelegate {
    
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        guard
//            let fromController = fromVC as? TapplNavigationController,
//            let toController = toVC as? TapplNavigationController
//        else { return nil }
        
        // как определить в какую сторону едем??
        
        
        return TapplSwitchAnimator()
    }
    
}
