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
        let finishFrameFromView = CGRect(x: TapplMagic.viewControllerPushedOffset,
                                         y: TapplMagic.previousControllerTopOffset,
                                         width: screenFrame.size.width - 2 * TapplMagic.viewControllerPushedOffset,
                                         height: screenFrame.size.height - TapplMagic.previousControllerTopOffset)
        fromViewController.view.frame = startFrame
        
        // fake view
        let fakeView = UIView(frame: CGRect(x: TapplMagic.viewControllerPushedOffset,
                                            y: TapplMagic.previousControllerTopOffset,
                                            width: screenFrame.size.width - 2 * TapplMagic.viewControllerPushedOffset,
                                            height: 100)) // от фонаря высота, все равно не видно
        fakeView.layer.cornerRadius = TapplMagic.fakeControllerCornerRadius
        fakeView.backgroundColor = TapplMagic.previousControllerColor
        fakeView.alpha = 0
        fakeView.frame = startFrame
        toViewController.shadowedView = fakeView
        toViewController.view.superview?.insertSubview(fakeView, belowSubview: toViewController.view)
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        finishFrame.origin.y = TapplMagic.currentControllerTopOffset
        toViewController.view.frame = finishFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        
        let toAnimate: BlockToAnimate = {
            toViewController.view.transform = .identity
            
            fromViewController.view.frame = finishFrameFromView
            fromViewController.view.layoutIfNeeded()
            
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
        
        let screenFrame = UIScreen.main.bounds
        let startFrameToView = CGRect(x: TapplMagic.viewControllerPushedOffset,
                                         y: TapplMagic.previousControllerTopOffset,
                                         width: screenFrame.size.width - 2 * TapplMagic.viewControllerPushedOffset,
                                         height: screenFrame.size.height - TapplMagic.previousControllerTopOffset)
        var finishFrameToView = transitionContext.finalFrame(for: toViewController)
        finishFrameToView.origin.y = TapplMagic.currentControllerTopOffset // ИЛИ 52 для самого 1го
        
        toViewController.view.frame = startFrameToView
        toViewController.view.alpha = 0
        
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        fromViewController.view.frame = startFrame
        
        toViewController.view.transform = .identity
        let toAnimate: BlockToAnimate = {
            toViewController.view.frame = finishFrameToView
            toViewController.view.layoutIfNeeded()
            toViewController.view.alpha = 1
            
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: startFrame.size.height)
            fromViewController.shadowedView?.alpha = 0
        }
        let toComplete: BlockToFinish = { _ in
            fromViewController.shadowedView = nil // TODO а проверить - может отменится поп?
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
}
