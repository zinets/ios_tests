//
//  FullScreenInteractiveDismissAnimator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 27.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class FullScreenInteractiveDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
            
    private var currentAnimator: UIViewImplicitlyAnimating?
    var tempView: ImageZoomView!
    
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        if let animator = currentAnimator {
            return animator
        }
        
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)
        if toView != nil {
            containerView.addSubview(toView!)
        }
        
        let fromViewController = transitionContext.viewController(forKey: .from) as! FullScreenController
        let fromView = transitionContext.view(forKey: .from)
        
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = fromViewController.startFrame!
        
        tempView = ImageZoomView(frame: startFrame)
        tempView.contentMode = .scaleAspectFit
        tempView.image = fromViewController.currentImage
        tempView.zoomScale = fromViewController.currentZoom ?? 1
        containerView.addSubview(tempView)
        
        fromView?.alpha = 0
        
        let duration = transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(duration: duration, curve: UIView.AnimationCurve.easeInOut)  {
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {

                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75) {
                }

                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                    self.tempView.contentMode = .scaleAspectFill
                    self.tempView.frame = finalFrame
                }

            }) { (_) in
                
            }
        }
        animator.addCompletion { succ in
            self.tempView.removeFromSuperview()
            self.tempView = nil
            
            if transitionContext.transitionWasCancelled {
                toView?.removeFromSuperview()
                fromView?.alpha = 1
            }
            self.currentAnimator = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        currentAnimator = animator
        return animator
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FullScreenAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)        
    }
}

