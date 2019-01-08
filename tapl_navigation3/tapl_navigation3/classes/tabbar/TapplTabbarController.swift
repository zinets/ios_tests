//
//  TapplTabbarController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplTabbarController: UITabBarController {
    
    private var interactiveAnimator = TapplSwitchInteractiveAnimator()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // включение тени (здесб и в навконтроллере!)
        for v in self.view.subviews {
            if v.clipsToBounds {
                v.clipsToBounds = false
            }
        }
        
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // для того чтобы таббар не просто скрылся, а и не влиял на автолаяуты, нужно в сториборде у таббара убрать галочку transfucent
        self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.bounds.size.height / 2)
        // или
//        self.tabBar.frame.origin.y += self.tabBar.frame.size.height / 2
//        self.tabBar.frame.size.height = 0
        // НО! все равно не работает
    }
    
    // вызывается при ините таббара где-то внутри..
    override var selectedViewController: UIViewController? {
        didSet {
            setupPanRecognizer()
        }
    }
    // вызывается при переключении после тапа по кнопке..
    override var selectedIndex: Int {
        didSet {
            setupPanRecognizer()
        }
    }
    
    // и надо панрекогнайзер надо подключить в вью контроллера, который теперь сверху
    private func setupPanRecognizer() {
        interactiveAnimator.setupSwitchGesture(viewController: selectedViewController)
        
    }
    

}

extension TapplTabbarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator.transitionInProgress ? interactiveAnimator : nil
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let _ = fromVC as? TapplNavigationController,
            let _ = toVC as? TapplNavigationController
            else { return nil }
        
        return TapplSwitchAnimator()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("\(viewController)")
    }
    
}
