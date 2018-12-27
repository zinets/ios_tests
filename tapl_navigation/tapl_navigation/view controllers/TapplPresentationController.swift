//
//  TapplPresentationController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/20/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplPresentationController: UIPresentationController {
    
    private var firstView: UIView?

    // это фрейм вью, которое показывается на экран; вернем его "правильный размер", т.е. с отступом сверху - тогда аниматор получит "финишный" размер с учетом этого отступа
    override var frameOfPresentedViewInContainerView: CGRect {
        let top: CGFloat = 10 + 20 + 4
        let x: CGFloat = 0
        let height = containerView!.bounds.height - top
        let width = containerView!.bounds.width
        
        let frame = CGRect(x: x, y: top, width: width, height: height)
        return frame
    }
    
//    override func containerViewWillLayoutSubviews() {
////        presentingViewController.view.frame = CGRect(x: 20, y: 0, width: containerView!.bounds.width - 40, height: containerView!.bounds.height)
//        var frame = frameOfPresentedViewInContainerView
//        frame.origin.x = 20
//        frame.size.width -= 40
//        presentedView?.frame = frame
//    }
    
//    override func presentationTransitionDidEnd(_ completed: Bool) {
//        let presented = self.presentedViewController
//        let presenting = self.presentingViewController
//        let view = self.presentingViewController.view
//        
//        if firstView == nil && presenting.presentingViewController == nil {
//            firstView = view!.snapshotView(afterScreenUpdates: true)
//            firstView?.frame.origin.y = -39 // 39???
//            
//            containerView?.insertSubview(firstView!, at: 0)
//            
//            guard let coordinator = presentedViewController.transitionCoordinator else {
//                return
//            }
//            coordinator.animate(alongsideTransition: { (_) in
//            
//            }) { (_) in
//                
//            }
//            
//        }
//        
//        print("completed \(completed)")
//        
//    }
    
}
