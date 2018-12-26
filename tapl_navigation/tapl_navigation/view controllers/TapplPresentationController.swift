//
//  TapplPresentationController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/20/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplPresentationController: UIPresentationController {

    // это фрейм вью, которое показывается на экран; вернем его "правильный размер", т.е. с отступом сверху - тогда аниматор получит "финишный" размер с учетом этого отступа
    override var frameOfPresentedViewInContainerView: CGRect {
        let top: CGFloat = 10
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
}
