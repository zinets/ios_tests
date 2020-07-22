//
//  FullScreenDismissAnimator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class FullScreenDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let containerView = transitionContext.containerView
        
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
        }
        
        let fromView = transitionContext.view(forKey: .from)
        
        let fromViewController = transitionContext.viewController(forKey: .from) as! FullScreenController
        
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = fromViewController.startFrame!
        
        let tempView = ImageZoomView(frame: startFrame)
        tempView.backgroundColor = .black
        tempView.contentMode = .scaleAspectFit
        tempView.image = fromViewController.currentImage
        tempView.zoomScale = fromViewController.currentZoom ?? 1
        containerView.addSubview(tempView)
        
        fromView?.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: FullScreenAnimationDuration, curve: UIView.AnimationCurve.easeInOut)
        animator.addAnimations {
            tempView.contentMode = .scaleAspectFill
            tempView.backgroundColor = .white
            tempView.frame = finalFrame
        }
        animator.addCompletion { succ in
            tempView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FullScreenAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }
    
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        return self.animator(using: transitionContext)
//    }
}
