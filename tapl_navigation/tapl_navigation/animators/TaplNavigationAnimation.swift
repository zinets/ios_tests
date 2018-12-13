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

let verticalShiftValue: CGFloat = 10.0
let horizontalShiftValue: CGFloat = 20.0

class TapplPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
   
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
        else { return }
       
        transitionContext.containerView.addSubview(toViewController.view)
        
        let stackHasUnderlayingView = fromViewController.navigationController!.viewControllers.count > 2
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        finishFrame.origin.y += verticalShiftValue
        finishFrame.size.height -= verticalShiftValue
        
        toViewController.handleIsVisible = true
        toViewController.view.frame = finishFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        
        fromViewController.view.transform = .identity
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            fromViewController.underlayingView?.alpha = 0
            fromViewController.handleIsVisible = false
            
            toViewController.view.transform = .identity
            
            let scale = (finishFrame.size.width - 2 * horizontalShiftValue) / finishFrame.size.width
            let h = ceil((finishFrame.size.height - finishFrame.size.height * scale) / 2 + (stackHasUnderlayingView ? verticalShiftValue : 0))
            
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: scale, y: scale)
            transform = transform.translatedBy(x: 0, y: -h)
            fromViewController.view.transform = transform
        }
        let toComplete: BlockToFinish = { _ in
            
            let iv = UIImageView(image: fromViewController.underlayingViewImage)
            iv.transform = fromViewController.view.transform
            iv.frame = fromViewController.view.frame
            toViewController.underlayingView = iv
            fromViewController.view.transform = .identity
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
    
}


class TapplPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
        else { return }
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        
        let stackHasUnderlayingView = fromViewController.navigationController!.viewControllers.count > 1
        
        if stackHasUnderlayingView {
            finishFrame.origin.y += verticalShiftValue
            toViewController.view.frame = finishFrame
            toViewController.handleIsVisible = true
        }
        
        fromViewController.underlayingView?.alpha = 0
        
        let scale = (finishFrame.size.width - 2 * horizontalShiftValue) / finishFrame.size.width
        let h = ceil((finishFrame.size.height - finishFrame.size.height * scale) / 2 + (stackHasUnderlayingView ? verticalShiftValue : 0))
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: scale, y: scale)
        transform = transform.translatedBy(x: 0, y: -h)
        toViewController.view.transform = transform
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
            toViewController.view.transform = .identity
            toViewController.underlayingView?.alpha = 1
        }
        let toComplete: BlockToFinish = { _ in
            fromViewController.view.transform = .identity
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
    
}

class TapplInteractiveAnimator: UIPercentDrivenInteractiveTransition {
    
    var controller : TapplBaseViewController
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    init?(attachTo viewController: UIViewController) {
        if let ctrl = viewController as? TapplBaseViewController, let handleView = ctrl.handleForBackGesture {
            self.controller = ctrl
            super.init()
            setupBackGesture(view: handleView)
        } else {
            return nil
        }
    }
    
    private func setupBackGesture(view : UIView) {
        let swipeBackGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let progress = viewTranslation.y / self.controller.view.frame.height
        print("progress = \(progress)")
        
        switch gesture.state {
        case .began:
            transitionInProgress = true
            controller.navigationController!.popViewController(animated: true)
            break
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            break
        case .cancelled:
            transitionInProgress = false
            cancel()
            break
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break
        default:
            return
        }
    }
    
}
