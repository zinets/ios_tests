//
//  PushAnimator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 31.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

protocol Transitionable {

    var view1: UIView? { get }

}

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = TimeInterval(UINavigationController.hideShowBarDuration)
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.5//duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(with: transitionContext)
        animator.startAnimation()
    }
    
    private func animator(with transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 1)
        
        let fromView = transitionContext.view(forKey: .from)
        guard let toView = transitionContext.view(forKey: .to) else {
            fatalError("toView!")
        }
        
        guard
            let fromCtrl = transitionContext.viewController(forKey: .from) as? Transitionable,
            let toCtrl = transitionContext.viewController(forKey: .to) as? Transitionable
            else {
                fatalError()
        }
        
        
        let contentView = transitionContext.containerView
        
        toView.alpha = 0
        contentView.addSubview(toView)
        
        guard let view1 = fromCtrl.view1?.snapshotView(afterScreenUpdates: true) else {
            fatalError()
        }
        view1.frame = fromCtrl.view1?.frame ?? .zero        
        contentView.addSubview(view1)

        
        
        animator.addAnimations {
            let view1FinalFrame = toCtrl.view1?.frame ?? .zero
            view1.frame = view1FinalFrame
        }
        
        animator.addCompletion { (_) in
            view1.removeFromSuperview()
            
            toView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
        return animator
    }
}
