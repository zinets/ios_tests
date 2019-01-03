//
//  TapplNavigationAnimators.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

typealias BlockToAnimate = () -> ()
typealias BlockToFinish = (Bool) -> ()

class TapplPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TapplMagic.navigationAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
        else { return }
        
        transitionContext.containerView.addSubview(toViewController.view)
        let duration = self.transitionDuration(using: transitionContext)
        
        let screenFrame = UIScreen.main.bounds
        
        // старый контроллер, начало
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        // старый контроллер, конечное положение
        let finishFrameFromView = CGRect(x: TapplMagic.viewControllerPushedOffset,
                                         y: TapplMagic.previousControllerTopOffset,
                                         width: screenFrame.size.width - 2 * TapplMagic.viewControllerPushedOffset,
                                         height: screenFrame.size.height - TapplMagic.previousControllerTopOffset)
        fromViewController.view.frame = startFrame
        
        // fake view
        let fakeView = UIView(frame: CGRect(x: TapplMagic.viewControllerPushedOffset,
                                            y: TapplMagic.previousControllerTopOffset,
                                            width: screenFrame.size.width - 2 * TapplMagic.viewControllerPushedOffset,
                                            height: 100)) // от фонаря высота, все равно не видно
        fakeView.layer.cornerRadius = TapplMagic.fakeControllerCornerRadius
        fakeView.backgroundColor = TapplMagic.previousControllerColor
        fakeView.alpha = 0
        fakeView.frame = startFrame
        toViewController.shadowedView = fakeView
        toViewController.view.superview?.insertSubview(fakeView, belowSubview: toViewController.view)
        
        var finishFrame = transitionContext.finalFrame(for: toViewController)
        finishFrame.origin.y = TapplMagic.currentControllerTopOffset
        toViewController.view.frame = finishFrame
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: finishFrame.size.height)
        
        let toAnimate: BlockToAnimate = {
            toViewController.view.transform = .identity
            
            fromViewController.view.frame = finishFrameFromView
            fromViewController.view.layoutIfNeeded()
            
            fromViewController.view.alpha = 0
            fakeView.frame = finishFrameFromView
            fakeView.alpha = 1
        }
        let toComplete: BlockToFinish = { _ in            
            fromViewController.view.alpha = 1
            fromViewController.view.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
    
}

class TapplPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TapplMagic.navigationAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TapplBaseViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? TapplBaseViewController
        else { return }
        
        transitionContext.containerView.clipsToBounds = false
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        let duration = self.transitionDuration(using: transitionContext)
        
        let screenFrame = UIScreen.main.bounds
        let startFrameToView = CGRect(x: TapplMagic.viewControllerPushedOffset,
                                         y: TapplMagic.previousControllerTopOffset,
                                         width: screenFrame.size.width - 2 * TapplMagic.viewControllerPushedOffset,
                                         height: screenFrame.size.height - TapplMagic.previousControllerTopOffset)
        var finishFrameToView = transitionContext.finalFrame(for: toViewController)
        if let navCtrl = toViewController.navigationController,
            navCtrl.viewControllers.count > 1 {
            finishFrameToView.origin.y = TapplMagic.currentControllerTopOffset            
        } else {
            finishFrameToView.origin.y = 0
        }
        
        toViewController.view.frame = startFrameToView
        toViewController.view.alpha = 0
        
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        fromViewController.view.frame = startFrame
        
        toViewController.view.transform = .identity
        let toAnimate: BlockToAnimate = {
            toViewController.view.frame = finishFrameToView
            toViewController.view.layoutIfNeeded()
            toViewController.view.alpha = 1
            
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: startFrame.size.height)
            fromViewController.shadowedView?.alpha = 0
        }
        let toComplete: BlockToFinish = { _ in
            if !transitionContext.transitionWasCancelled {
                fromViewController.shadowedView = nil
            } else {
                fromViewController.shadowedView?.alpha = 1
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
}

class TapplSwitchAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TapplMagic.navigationAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from),
            let tabbarCtrl = fromViewController.tabBarController,
            let fromView = fromViewController.view,
            let toView = toViewController.view
            else { return }
        
        let fromIndex = tabbarCtrl.viewControllers?.firstIndex(of: fromViewController)
        let toIndex = tabbarCtrl.viewControllers?.firstIndex(of: toViewController)
        
        let directionRight = toIndex! > fromIndex!
        
        transitionContext.containerView.addSubview(fromView)
        transitionContext.containerView.addSubview(toView)
        
        let duration = self.transitionDuration(using: transitionContext)
        let startFrameFromVC = transitionContext.initialFrame(for: fromViewController)
        let width = startFrameFromVC.size.width
        let finishFrameFromVC = startFrameFromVC.offsetBy(dx: (directionRight ? -width / 3 : width / 3), dy: 0)
        
        let finishFrameToVC = transitionContext.finalFrame(for: toViewController)
        let startFrameToVC = finishFrameToVC.offsetBy(dx: (directionRight ? width : -width), dy: 0)
        
        
        fromView.frame = startFrameFromVC
        toView.frame = startFrameToVC
        
        let toAnimate: BlockToAnimate = {
            fromView.frame = finishFrameFromVC
            toView.frame = finishFrameToVC
        }
        let toComplete: BlockToFinish = { _ in
            if transitionContext.transitionWasCancelled {
                fromView.frame = startFrameFromVC
                toView.frame = startFrameToVC
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: duration, animations: toAnimate, completion: toComplete)
    }
    
}

class TapplSwitchInteractiveAnimator: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    
    private var panRecognizer: UIPanGestureRecognizer?
    private var controller : UIViewController!
    private var shouldCompleteTransition = false
    var transitionInProgress = false
    
    func setupSwitchGesture(viewController: UIViewController?) {
        guard
            viewController != controller,
            viewController is TapplNavigationController
            else { return }
        
        controller = viewController
        
        if let ctrl = controller as? TapplNavigationController, ctrl.panInteractiveRecognizer == nil {
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            ctrl.panInteractiveRecognizer = recognizer
        }
        
    }
    
    private var toRightSwipe = false
    @objc func onPan(_ sender: UIPanGestureRecognizer) {
        let velosity = sender.velocity(in: sender.view)
        let translation = sender.translation(in: sender.view)
        
        switch sender.state {
        case .began:
            if abs(velosity.x) < abs(velosity.y) {
                transitionInProgress = false
                return
            }
            
            toRightSwipe = velosity.x > 0 // уменьшаем индекс
            transitionInProgress = true
            // вдруг кто-то сделает таббар с 1м табом? самсебе доктор..
            let tabbarCtrl = controller.tabBarController!
            if toRightSwipe && tabbarCtrl.selectedIndex > 0 {
                tabbarCtrl.selectedIndex -= 1
            } else if !toRightSwipe && tabbarCtrl.selectedIndex < tabbarCtrl.viewControllers!.count - 1 {
                tabbarCtrl.selectedIndex += 1
            }
        case .changed:
            let translationValue = min(0.99, max(0, abs(translation.x / UIScreen.main.bounds.size.width)))
            print("\(translationValue)")
            shouldCompleteTransition = translationValue > 0.5
            update(translationValue)
        case .cancelled:
            transitionInProgress = false
            cancel()
        case .ended:
            if transitionInProgress {
                transitionInProgress = false
                
                shouldCompleteTransition ? finish() : cancel()
            }
        default:
            break
        }
    }
    
    // MARK: - gesture
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
