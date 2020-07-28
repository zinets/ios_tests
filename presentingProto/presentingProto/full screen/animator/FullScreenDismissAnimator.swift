//
//  FullScreenDismissAnimator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class FullScreenDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.35
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)
        if toView != nil {
            containerView.addSubview(toView!)
        }
        
        let fromView = transitionContext.view(forKey: .from)
        
        let fromViewController = transitionContext.viewController(forKey: .from) as! FullScreenController
        
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = fromViewController.startFrame!
        
        let tempView = ImageZoomView(frame: startFrame)
        tempView.contentMode = .scaleAspectFit
        tempView.image = fromViewController.currentImage
        tempView.zoomScale = fromViewController.currentZoom ?? 1
        containerView.addSubview(tempView)
        
        fromView?.alpha = 0
                        
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: UIView.AnimationCurve.easeInOut)  {
            tempView.contentMode = .scaleAspectFill            
            tempView.frame = finalFrame
        }
        animator.addCompletion { succ in
            tempView.removeFromSuperview()
            if transitionContext.transitionWasCancelled {
                toView?.removeFromSuperview()
                fromView?.alpha = 1
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        animator.startAnimation()
    }
}
