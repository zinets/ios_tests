//
//  PresentationController.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//
import UIKit


// МЮСЛИ:  этот презентер может же использоваться не только для фулскрина, но и для показа контроллена скажем на 1/3 экрана - суть его в полупрозрачной подложке, которая показывается сихронно с появлением/удалением модально-показываемого контроллера
// это же полупрозрачное вью может ловить тапы "мимо" контроллера, чтобы закрывать его
// но без понятия пока про синхронизацтю поведения этого контроллера и того, которого презентим (скорее аниматор должен быть в курсе?) - он же должен быть в курсе своего будуЮщего размера..
class FullscreenPresentationController: UIPresentationController {
    
    override var shouldPresentInFullscreen: Bool {
        return false // почему false?
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        // фулскрин
        return containerView!.bounds
        
        // треть-скрин
//        let bounds = containerView!.bounds
//        let height: CGFloat = 300.0
//        return CGRect(x: 0.0, y: height, width: bounds.width, height: height)
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
    var dimmColor: UIColor = .red {
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

