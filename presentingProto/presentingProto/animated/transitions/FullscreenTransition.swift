//
//  FullscreenTransition.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class FullscreenTransition: NSObject, UIViewControllerTransitioningDelegate {
        
    // допустим у меня будут свойства с нужным аниматором, а если не задан - буду создавать какой-то "дефолтный"
    var presentAnimator: UIViewControllerAnimatedTransitioning?
    var dismissAnimator: UIViewControllerAnimatedTransitioning?
    
    // а с интерактивностью я пока не хочу играться
    private let driver = TransitionDriver()
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        driver.link(to: presented)
        
        let presentationController = FullscreenPresentationController(presentedViewController: presented,
                                                                presenting: presenting ?? source)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = presentAnimator else {
            return FullScreenPresentAnimator()
        }
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = presentAnimator else {
            return FullScreenDismissAnimator()
        }
        return animator
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }

}
