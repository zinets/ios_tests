//
//  PresentationController.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//
import UIKit

class FullscreenPresentationController: UIPresentationController {
    
    override var shouldPresentInFullscreen: Bool {
        return false // почему false?
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        // фулскрин
        return containerView!.bounds
        
        // треть-скрин
//        let bounds = containerView!.bounds
//        let height = 300
//        return CGRect(x: 0, y: height, width: bounds.width, height: halfHeight)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        containerView?.addSubview(presentedView!)
        containerView?.insertSubview(dimmedView, at: 0)
        performAlongsideTransition { [unowned self] in
            self.dimmedView.alpha = 1
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        presentedView?.frame = frameOfPresentedViewInContainerView
        dimmedView.frame = containerView!.frame
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            self.dimmedView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        performAlongsideTransition { [unowned self] in
            self.dimmedView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            self.dimmedView.removeFromSuperview()
        }
    }
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = self.dimmColor
        view.alpha = 0
        
        return view
    }()
    var dimmColor: UIColor = .black {
        didSet {
            dimmedView.backgroundColor = dimmColor
        }
    }
        
    private func performAlongsideTransition(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }
            
        coordinator.animate(alongsideTransition: { (_) in
            block()
        }, completion: nil)
    }

}

