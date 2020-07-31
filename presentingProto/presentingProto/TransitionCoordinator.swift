//
//  TransitionCoordinator.swift
//  presentingProto
//
//  Created by Viktor Zinets on 31.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

// TimeInterval(UINavigationControllerHideShowBarDuration))
class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
 
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return PushAnimator()
        default:
            return nil
        }
    }
}
