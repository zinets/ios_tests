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

let verticalShiftValue: CGFloat = 10
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
        let duration = self.transitionDuration(using: transitionContext)
        
        // to view
        let y: CGFloat = 72 + verticalShiftValue
        var toViewFinishFrame = transitionContext.finalFrame(for: toViewController)
        toViewController.additionalSpaceFromTop = y
        toViewController.handleIsVisible = true
        toViewFinishFrame.origin.y = y
        toViewFinishFrame.size.height = UIScreen.main.bounds.size.height - y
        
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: toViewFinishFrame.size.height)
        
        // from view
        let fromViewFinishFrame = fromViewController.view.frame
        let scale = (fromViewFinishFrame.size.width - 2 * horizontalShiftValue) / fromViewFinishFrame.size.width
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: scale, y: scale)
        
        let stackHasUnderlayingView = fromViewController.navigationController!.viewControllers.count > 2
        let h = ceil((fromViewFinishFrame.size.height - fromViewFinishFrame.size.height * scale) / 2) + (stackHasUnderlayingView ? verticalShiftValue : 0)
        transform = transform.translatedBy(x: 0, y: -h)
        
        let toAnimate: BlockToAnimate = {
            toViewController.view.transform = .identity
            
            fromViewController.handleIsVisible = false
            fromViewController.underlayingView?.alpha = 0
            fromViewController.view.transform = transform
        }
        let toComplete: BlockToFinish = { _ in
            let iv = UIImageView(image: fromViewController.underlayingViewImage)
            iv.transform = fromViewController.view.transform
            iv.frame = fromViewController.view.frame
            toViewController.underlayingView = iv
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
        
    }
    
}

class TapplPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var poppingController: TapplBaseViewController?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
        
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
        else { return }
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        let finishFrame = transitionContext.initialFrame(for: fromViewController)
        toViewController.view.transform = fromViewController.underlayingView!.transform
        toViewController.view.frame = fromViewController.underlayingView!.frame
        toViewController.underlayingView?.alpha = 0
        let stackHasUnderlayingView = fromViewController.navigationController!.viewControllers.count > 1
        if stackHasUnderlayingView {
            toViewController.handleIsVisible = true
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        let toAnimate: BlockToAnimate = {
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
            fromViewController.underlayingView?.alpha = 0
            toViewController.underlayingView?.alpha = 1
            
            toViewController.view.transform = .identity
        }
        let toComplete: BlockToFinish = { _ in
            fromViewController.view.transform = .identity
            
            if transitionContext.transitionWasCancelled {
                toViewController.underlayingView?.alpha = 0
                fromViewController.underlayingView?.alpha = 1
            } else {
                fromViewController.underlayingView = nil
            }
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

class TapplSwitchAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplNavigationController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplNavigationController,
            let tabbarCtrl = fromViewController.tabBarController,
            
            let fromView = fromViewController.topViewController?.view.snapshotView(afterScreenUpdates: true),
            let toView = toViewController.topViewController?.view as? TapplBaseView
        else { return }
        
        let fromIndex = tabbarCtrl.viewControllers?.firstIndex(of: fromViewController)
        let toIndex = tabbarCtrl.viewControllers?.firstIndex(of: toViewController)
        
        let directionRight = toIndex! > fromIndex!
        let underLayingView = (toViewController.topViewController as? TapplBaseViewController)?.underlayingView
        
        transitionContext.containerView.addSubview(toViewController.view)
        fromView.frame = fromViewController.topViewController!.view.frame
        transitionContext.containerView.addSubview(fromView)

        let duration = self.transitionDuration(using: transitionContext)
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        let finishFrame = transitionContext.finalFrame(for: toViewController)

        toView.transform = CGAffineTransform(translationX: (directionRight ? 1 : -1) * finishFrame.size.width, y: 0)
        let storedTransform = underLayingView?.transform
        if let transform = storedTransform {
            underLayingView?.transform = transform.translatedBy(x: (directionRight ? 1 : -1) * finishFrame.size.width, y: 0)
        }
        
        let toAnimate: BlockToAnimate = {
            toView.transform = .identity
            if let transform = storedTransform {
                underLayingView?.transform = transform
            }
            fromView.transform = CGAffineTransform(translationX: (directionRight ? -1 : 1) * startFrame.size.width, y: 0)
        }
        let toComplete: BlockToFinish = { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }

}
