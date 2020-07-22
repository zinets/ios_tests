//
//  FullScreenFadeDismissAnimator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

// чото этот аниматор вообще не работает
class FullScreenFadeDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FullScreenAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
        
        UIView.animate(withDuration: FullScreenAnimationDuration, animations: {
            fromView?.alpha = 0
            blackView.backgroundColor = .clear
            fromView?.transform = CGAffineTransform(translationX: 0, y: (fromView?.bounds.height)!)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}


