//
//  TapplNavigationController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/11/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // .backgroundColor = UIColor(rgb: 0xf9f8f6) // TODO: как получить цвет того бг,
        self.view.backgroundColor = UIColor(rgb: 0xf9f8f6)
    }

}

extension TapplNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            if let ctrl = toVC as? TapplBaseViewController {
                ctrl.interactiveAnimator = TapplInteractiveAnimator(attachTo: toVC)
            }
            return TapplPushAnimator()
        case .pop:
            let popAnimator = TapplPopAnimator()
            popAnimator.poppingController = fromVC as? TapplBaseViewController
            return popAnimator
        default:
            return nil
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard
            let animator = animationController as? TapplPopAnimator,
            let ctrl = animator.poppingController,
            let ia = ctrl.interactiveAnimator
            else {
                return nil
        }
        return ia.transitionInProgress ? ia : nil
    }
}
