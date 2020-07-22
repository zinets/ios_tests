//
//  FullScreenAnimators.swift
//  mdukProfileProto
//
//  Created by Victor Zinets on 8/7/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit
let FullScreenAnimationDuration: TimeInterval = 0.35

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

class FullScreenDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FullScreenAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
        }
        
        let fromView = transitionContext.view(forKey: .from)
        
        let fromViewController = transitionContext.viewController(forKey: .from) as! FullScreenController
        
        let startFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = fromViewController.startFrame!
        
        let tempView = ImageZoomView(frame: startFrame)
        tempView.backgroundColor = .black
        tempView.contentMode = .scaleAspectFit
        tempView.image = fromViewController.currentImage
        tempView.zoomScale = fromViewController.currentZoom ?? 1
        containerView.addSubview(tempView)
        
        fromView?.alpha = 0
        
        UIView.animate(withDuration: FullScreenAnimationDuration, animations: {
            tempView.contentMode = .scaleAspectFill
            tempView.backgroundColor = .white
            tempView.frame = finalFrame
        }, completion: { _ in
            tempView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
}

class FullScreenFadePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        // фото будет увеличиваться при переходе в фулскрин; чтобы его копия не осталась на месте - заложу ее белым прямоугольником
        let whiteView = UIView(frame: startFrame)
        whiteView.backgroundColor = .white
        containerView.addSubview(whiteView)
        
        // поверх текущего контента ложу прозрачную вью на весь контент, чей цвет поменяется к концу перехода на черный - чтобы увеличивалась только фотография, а не все вью с черными областями
        let fadedBgView = UIView(frame: containerView.bounds)
        fadedBgView.backgroundColor = .clear
        containerView.addSubview(fadedBgView)
        
        let tempView = ImageZoomView(frame: startFrame)
        tempView.contentMode = .scaleAspectFill
        tempView.image = toViewController.startImage
        containerView.addSubview(tempView)
        
        UIView.animate(withDuration: FullScreenAnimationDuration, animations: {
            tempView.contentMode = .scaleAspectFit
            fadedBgView.backgroundColor = .black
            tempView.frame = finalFrame
        }, completion: { _ in
            whiteView.removeFromSuperview()
            tempView.removeFromSuperview()
            fadedBgView.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
    }
}

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




/// переход в фулскрин для LA - у которого уголки фото профиля скруглены, пробую пофиксить раньше, чем богдан напишет, что бага
class LAFullScreenPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        tempView.layer.cornerRadius = 32
        tempView.clipsToBounds = true
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
