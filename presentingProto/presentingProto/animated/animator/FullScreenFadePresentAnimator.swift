//
//  FullScreenFadePresentAnimator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
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
        // АХТУНГ: эта идея с белой вью такая дичь :D
        let whiteView = UIView(frame: startFrame)
        whiteView.backgroundColor = .white
        containerView.addSubview(whiteView)
        
//        // поверх текущего контента ложу прозрачную вью на весь контент, чей цвет поменяется к концу перехода на черный - чтобы увеличивалась только фотография, а не все вью с черными областями
//        let fadedBgView = UIView(frame: containerView.bounds)
//        fadedBgView.backgroundColor = .clear
//        containerView.addSubview(fadedBgView)
        
        let tempView = ImageZoomView(frame: startFrame)
        tempView.contentMode = .scaleAspectFill
        tempView.image = toViewController.startImage
        containerView.addSubview(tempView)
        
        UIView.animate(withDuration: FullScreenAnimationDuration, animations: {
            tempView.contentMode = .scaleAspectFit
//            fadedBgView.backgroundColor = .black
            tempView.frame = finalFrame
        }, completion: { _ in
            whiteView.removeFromSuperview()
            tempView.removeFromSuperview()
//            fadedBgView.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
    }
}


