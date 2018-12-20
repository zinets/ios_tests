//
//  TapplPresentationController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/20/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        let height = containerView!.bounds.height - 10
        let width = containerView!.bounds.width
        return CGRect(x: 0, y: 10, width: width, height: height)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentingViewController.view.frame = CGRect(x: 20, y: 0, width: containerView!.bounds.width - 40, height: containerView!.bounds.height)
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
