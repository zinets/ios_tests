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
        
        let stackHasUnderlayingView = fromViewController.navigationController!.viewControllers.count > 2
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        finishFrame.origin.y += verticalShiftValue
        finishFrame.size.height -= verticalShiftValue
        
        toViewController.view.frame = finishFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        
        fromViewController.view.transform = .identity
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            toViewController.view.transform = .identity
            
            let scale = (finishFrame.size.width - 2 * self.horizontalShiftValue) / finishFrame.size.width
            let h = ceil((finishFrame.size.height - finishFrame.size.height * scale) / 2 + (stackHasUnderlayingView ? self.verticalShiftValue : 0))
            
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: scale, y: scale)
            transform = transform.translatedBy(x: 0, y: -h)
            fromViewController.view.transform = transform
        }
        let toComplete: BlockToFinish = { _ in

            if let navCtrl = fromViewController.navigationController as? TapplNavigationController, let replicant = fromViewController.view.snapshotView(afterScreenUpdates: true) {
                var frame = navCtrl.view.convert(fromViewController.view.frame, from: transitionContext.containerView)
//                frame.origin.y -= 30
//                let view = UIView(frame: frame)
//                view.backgroundColor = UIColor.brown
//
//                navCtrl.view.insertSubview(view, at: 1)
                
//                navCtrl.phantomView.frame = frame                
            }
            
            fromViewController.view.transform = .identity
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
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
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        
        let stackHasUnderlayingView = fromViewController.navigationController!.viewControllers.count > 1
        var startFrame = transitionContext.initialFrame(for: fromViewController)
        
        if stackHasUnderlayingView {
            finishFrame.origin.y += self.verticalShiftValue
            toViewController.view.frame = finishFrame
        }
        
        let scale = (finishFrame.size.width - 2 * self.horizontalShiftValue) / finishFrame.size.width
        let h = ceil((finishFrame.size.height - finishFrame.size.height * scale) / 2 + (stackHasUnderlayingView ? self.verticalShiftValue : 0))
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: scale, y: scale)
        transform = transform.translatedBy(x: 0, y: -h)
        toViewController.view.transform = transform
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: startFrame.size.height)
            toViewController.view.transform = .identity
        }
        let toComplete: BlockToFinish = { _ in
            fromViewController.view.transform = .identity
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
    
}
