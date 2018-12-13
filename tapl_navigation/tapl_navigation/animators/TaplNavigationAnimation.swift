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

let verticalShiftValue: CGFloat = 10.0
let horizontalShiftValue: CGFloat = 20.0

class TapplPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
   
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
        else { return }
       
        transitionContext.containerView.addSubview(toViewController.view)
        
        let stackHasUnderlayingView = fromViewController.navigationController!.viewControllers.count > 2
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        finishFrame.origin.y += verticalShiftValue
        finishFrame.size.height -= verticalShiftValue
        
        toViewController.view.frame = finishFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        
        fromViewController.view.transform = .identity
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            fromViewController.underlayingView?.alpha = 0
            toViewController.view.transform = .identity
            
            let scale = (finishFrame.size.width - 2 * horizontalShiftValue) / finishFrame.size.width
            let h = ceil((finishFrame.size.height - finishFrame.size.height * scale) / 2 + (stackHasUnderlayingView ? verticalShiftValue : 0))
            
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: scale, y: scale)
            transform = transform.translatedBy(x: 0, y: -h)
            fromViewController.view.transform = transform
        }
        let toComplete: BlockToFinish = { _ in

            let iv = UIImageView(image: fromViewController.underlayingViewImage)
            iv.transform = fromViewController.view.transform
            iv.frame = fromViewController.view.frame
            toViewController.underlayingView = iv
            fromViewController.view.transform = .identity
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
    
}


class TapplPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
        else { return }
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        
        let stackHasUnderlayingView = fromViewController.navigationController!.viewControllers.count > 1
        var startFrame = transitionContext.initialFrame(for: fromViewController)
        
        if stackHasUnderlayingView {
            finishFrame.origin.y += verticalShiftValue
            toViewController.view.frame = finishFrame
        }
        
        fromViewController.underlayingView?.alpha = 0
        
        let scale = (finishFrame.size.width - 2 * horizontalShiftValue) / finishFrame.size.width
        let h = ceil((finishFrame.size.height - finishFrame.size.height * scale) / 2 + (stackHasUnderlayingView ? verticalShiftValue : 0))
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: scale, y: scale)
        transform = transform.translatedBy(x: 0, y: -h)
        toViewController.view.transform = transform
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: startFrame.size.height)
            toViewController.view.transform = .identity
            toViewController.underlayingView?.alpha = 1
        }
        let toComplete: BlockToFinish = { _ in
            fromViewController.view.transform = .identity
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
    
}
