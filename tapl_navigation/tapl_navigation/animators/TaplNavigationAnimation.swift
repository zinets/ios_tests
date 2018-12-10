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
    
    let verticalShiftValue: CGFloat = 10.0
    let horizontalShiftValue: CGFloat = 20.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
   
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else { return }
        
        transitionContext.containerView.backgroundColor = UIColor(rgb: 0xf9f8f6) // TODO: как получить цвет того бг, которыое видно в уголках? toViewController.view.backgroundColor
        transitionContext.containerView.addSubview(toViewController.view)
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        finishFrame.origin.y += verticalShiftValue
        finishFrame.size.height -= verticalShiftValue
        toViewController.view.frame = finishFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        
        var startFrame = transitionContext.initialFrame(for: fromViewController)
        startFrame.origin.x = horizontalShiftValue
        startFrame.size.width -= 2 * horizontalShiftValue
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            toViewController.view.transform = .identity
            fromViewController.view.frame = startFrame
        }
        UIView.animate(withDuration: duration, animations: toAnimate) { (finished) in
            if let replicant = fromViewController.view.snapshotView(afterScreenUpdates: true) {
                startFrame.origin.y = -self.verticalShiftValue
                startFrame.size.height -= self.verticalShiftValue
                replicant.frame = startFrame
                replicant.tag = 73465;
                toViewController.view.insertSubview(replicant, at: 0)
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
}


class TapplPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let verticalShiftValue: CGFloat = 10.0
    let horizontalShiftValue: CGFloat = 20.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else { return }

        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        if let view = fromViewController.view.viewWithTag(73465) {
            toViewController.view.frame = view.frame
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            let finishFrame = transitionContext.finalFrame(for: toViewController)
            toViewController.view.frame = finishFrame
            if let view = fromViewController.view.viewWithTag(73465) {
                view.removeUnderliedView()
            }
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        }
        UIView.animate(withDuration: duration, animations: toAnimate) { (finished) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
