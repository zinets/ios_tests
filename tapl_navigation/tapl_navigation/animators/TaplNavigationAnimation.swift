//
//  TaplNavigationAnimation.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/10/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

typealias BlockToAnimate = () -> ()
typealias BlockToFinish = (Bool) -> ()

class TapplPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
   
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else { return }
        
        transitionContext.containerView.backgroundColor = UIColor.yellow
        transitionContext.containerView.addSubview(toViewController.view)
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        finishFrame.origin.y += 10
        finishFrame.size.height -= 10
        toViewController.view.frame = finishFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        
        var startFrame = transitionContext.initialFrame(for: fromViewController)
        startFrame.origin.x = 20
        startFrame.size.width -= 40
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            toViewController.view.transform = .identity
            fromViewController.view.frame = startFrame
        }
        UIView.animate(withDuration: duration, animations: toAnimate) { (finished) in
            if let replicant = fromViewController.view.snapshotView(afterScreenUpdates: true) {
                startFrame.origin.y = -10
                replicant.frame = startFrame
                toViewController.view.insertSubview(replicant, at: 0)
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
}
