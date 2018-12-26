//
//  TapplPresentationDelegate.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/20/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplPresentationDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TapplPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TapplPresentationPushAnimator()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TapplPresentationPopAnimator()
    }


}

class TapplPresentationPushAnimator:  NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else { return }
        
        transitionContext.containerView.addSubview(toViewController.view)
        let duration = self.transitionDuration(using: transitionContext)
        
        var toFrame = transitionContext.finalFrame(for: toViewController)
        toViewController.view.frame = toFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: toFrame.size.height)
       
        toFrame = transitionContext.finalFrame(for: toViewController)
        toFrame.origin = CGPoint(x: 20, y: 20 + 4)
        toFrame.size.width -= 20 * 2
        
        let toAnimate: BlockToAnimate = {
            toViewController.view.transform = .identity
            if fromViewController.presentingViewController != nil {
                fromViewController.view.frame = toFrame
            }
        }
        let toComplete: BlockToFinish = { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}

class TapplPresentationPopAnimator:  NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else { return }
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        let fromFrame = transitionContext.initialFrame(for: fromViewController)
        fromViewController.view.frame = fromFrame
        
        var toFrame = fromFrame
        if toViewController.presentingViewController == nil {
            toFrame = transitionContext.finalFrame(for: toViewController)
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            toViewController.view.frame = toFrame
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: fromFrame.size.height)
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
