//
//  FullScreenFadeDismissAnimator.swift
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class FullScreenFadeDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FullScreenAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator(using: transitionContext).startAnimation()
    }
    
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let containerView = transitionContext.containerView
        
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
        }
        
        let blackView = UIView(frame: containerView.bounds)
        blackView.backgroundColor = .black
        containerView.addSubview(blackView)
        
        let fromView = transitionContext.view(forKey: .from)
        fromView?.backgroundColor = .clear
        containerView.bringSubviewToFront(fromView!)
        
        let animator = UIViewPropertyAnimator(duration: FullScreenAnimationDuration, curve: .easeInOut) {
            fromView?.alpha = 0
            blackView.backgroundColor = .clear
            fromView?.transform = CGAffineTransform(translationX: 0, y: (fromView?.bounds.height)!)
        }
        animator.addCompletion { (pos) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return animator(using: transitionContext)
    }
}



