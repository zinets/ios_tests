//
//  PushAnimator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 31.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = TimeInterval(UINavigationController.hideShowBarDuration)
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(true)
    }
    
    
}
