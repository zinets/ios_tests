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
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return animator(using: transitionContext)
    }
        
    private var animator: UIViewImplicitlyAnimating?
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        if let animator = self.animator {
            return animator
        }
        
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
        
        let tempView = ImageZoomView(frame: startFrame)
        tempView.backgroundColor = .clear
        tempView.contentMode = .scaleAspectFit
        tempView.image = fromViewController.currentImage
        tempView.zoomScale = fromViewController.currentZoom ?? 1
        containerView.addSubview(tempView)
        
        fromView?.alpha = 0
        let cornerRadius = fromViewController.proposedCornerRadius ?? 0
        let mainAnimator = cornerRadius > 0 ? (UIViewPropertyAnimator(duration: FullScreenAnimationDuration, curve: .easeOut)) : (UIViewPropertyAnimator(duration: FullScreenAnimationDuration, dampingRatio: 0.8))
        
        let finalizationAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn)
        
        mainAnimator.addAnimations {
            tempView.contentMode = .scaleAspectFill
            tempView.frame = finalFrame
//            let t = self.transitionImageScaleFor(percentageComplete: 1 - mainAnimator.fractionComplete)
//            tempView.transform = CGAffineTransform.identity
//                           .scaledBy(x: t, y: t)
            tempView.backgroundColor = .red
            
            tempView.layer.cornerRadius = cornerRadius
        }
        mainAnimator.addCompletion { pos in
            beforeDisappearBlock?()
            finalizationAnimator.startAnimation()
        }
        finalizationAnimator.addAnimations {
            afterDisappearBlock?()
        }
        finalizationAnimator.addCompletion { [weak transitionContext] (pos) in
            guard let transitionContext = transitionContext else { fatalError() }
            tempView.removeFromSuperview()
            
            if transitionContext.transitionWasCancelled {
                fromView?.alpha = 1
                transitionContext.cancelInteractiveTransition()
                transitionContext.completeTransition(false)
            } else {
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)                
            }
        }
        
        self.animator = mainAnimator
        return mainAnimator    
    }
    
    func transitionImageScaleFor(percentageComplete: CGFloat) -> CGFloat {
        let minScale = CGFloat(0.68)
        let result = 1 - (1 - minScale) * percentageComplete
        return result
    }
}

