//
//  TapplNavigationAnimators.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

typealias BlockToAnimate = () -> ()
typealias BlockToFinish = (Bool) -> ()

class TapplPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TapplMagic.navigationAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
        else { return }
        
        transitionContext.containerView.addSubview(toViewController.view)
        let duration = self.transitionDuration(using: transitionContext)
        
        let screenFrame = UIScreen.main.bounds
        
        // старый контроллер, начало
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        // старый контроллер, конечное положение
        let finishFrameFromView = CGRect(x: 20, y: 4, width: screenFrame.size.width - 40, height: screenFrame.size.height - 4)
        fromViewController.view.frame = startFrame
        
        // fake view
        let fakeView = UIView(frame: CGRect(x: 20, y: 4, width: screenFrame.size.width - 40, height: 100))
        fakeView.layer.cornerRadius = 12
        fakeView.backgroundColor = TapplMagic.previousControllerColor
        fakeView.alpha = 0
        fakeView.frame = startFrame
        toViewController.shadowedView = fakeView
        toViewController.view.superview?.insertSubview(fakeView, belowSubview: toViewController.view)
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        finishFrame.origin.y = 20
        toViewController.view.frame = finishFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        
        let toAnimate: BlockToAnimate = {
            toViewController.view.transform = .identity
            
            fromViewController.view.frame = finishFrameFromView
            fromViewController.view.alpha = 0
            fakeView.frame = finishFrameFromView
            fakeView.alpha = 1
        }
        let toComplete: BlockToFinish = { _ in
            
            
            fromViewController.view.alpha = 1
            fromViewController.view.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
    
}

class TapplPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TapplMagic.navigationAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
            else { return }
        
        transitionContext.containerView.clipsToBounds = false
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        let duration = self.transitionDuration(using: transitionContext)
        
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        let finishFrame = transitionContext.finalFrame(for: toViewController)
        
        fromViewController.view.frame = startFrame
        toViewController.view.frame = finishFrame
        
        toViewController.view.transform = .identity
        let toAnimate: BlockToAnimate = {
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        }
        let toComplete: BlockToFinish = { _ in
            fromViewController.shadowedView = nil // TODO а проверить - может отменится поп?
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
}
