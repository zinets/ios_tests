//
//  FullScreenPresentAnimator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class FullScreenPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FullScreenAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)!
        let toViewController = transitionContext.viewController(forKey: .to) as! FullScreenController
        
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let startFrame = toViewController.startFrame!
        
        containerView.addSubview(toView)
        toView.alpha = 0
        
        let tempView = ImageZoomView(frame: startFrame)
        tempView.backgroundColor = .white
        tempView.contentMode = .scaleAspectFill
        tempView.image = toViewController.startImage
        containerView.addSubview(tempView)
        
        UIView.animate(withDuration: FullScreenAnimationDuration, animations: {
            tempView.contentMode = .scaleAspectFit
            tempView.backgroundColor = .black
            tempView.frame = finalFrame
        }, completion: { _ in
            tempView.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
    }
}
