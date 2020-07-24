//
//  DismissAnimatorLikeFB.swift
//  presentingProto
//
//  Created by Viktor Zinets on 24.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class DismissAnimatorLikeFB: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FullScreenAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator(using: transitionContext).startAnimation()
    }
    
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        return animator(using: transitionContext)
//    }
    
    private var tempView: ImageZoomView!
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        let containerView = transitionContext.containerView
        
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
        }
        
        let fromView = transitionContext.view(forKey: .from)
        
        let fromViewController = transitionContext.viewController(forKey: .from) as! FullScreenController
        
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = fromViewController.startFrame!
        

        let beforeDisappearBlock = fromViewController.beforeDisappear
        let afterDisappearBlock = fromViewController.afterDisappear
        
        tempView = ImageZoomView(frame: startFrame)
        tempView.backgroundColor = .black
        tempView.contentMode = .scaleAspectFit
        tempView.image = fromViewController.currentImage
        tempView.zoomScale = fromViewController.currentZoom ?? 1
        containerView.addSubview(tempView)
        
        fromView?.alpha = 0
        let cornerRadius = fromViewController.proposedCornerRadius ?? 0
        let mainAnimator = cornerRadius > 0 ? (UIViewPropertyAnimator(duration: FullScreenAnimationDuration, curve: .easeOut)) : (UIViewPropertyAnimator(duration: FullScreenAnimationDuration, dampingRatio: 0.8))
        
        let finalizationAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn)
        
        mainAnimator.addAnimations {
            self.tempView.contentMode = .scaleAspectFill
            self.tempView.frame = finalFrame
            self.tempView.backgroundColor = .clear
            
            self.tempView.layer.cornerRadius = cornerRadius
        }
        mainAnimator.addCompletion { pos in
            self.tempView.removeFromSuperview()
            
            beforeDisappearBlock?()
            finalizationAnimator.startAnimation()
        }
        finalizationAnimator.addAnimations {
            afterDisappearBlock?()
        }
        finalizationAnimator.addCompletion { (pos) in
            transitionContext.completeTransition(pos == .end)
        }
        
        return mainAnimator
    
    }
}

