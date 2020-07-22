//
//  TransitionDriver.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//
import UIKit

class TransitionDriver: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Linking
    func link(to controller: UIViewController) {
        presentedController = controller
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        presentedController?.view.addGestureRecognizer(panRecognizer!)
    }
    
    private weak var presentedController: UIViewController?
    private var panRecognizer: UIPanGestureRecognizer?
    
    
    // MARK: - Override
    override var wantsInteractiveStart: Bool {
        get {
            let gestureIsActive = panRecognizer?.state == .began
            return gestureIsActive
        }
        
        set { }
    }
    
    @objc private func handle(recognizer r: UIPanGestureRecognizer) {
        switch r.state {
        case .began:
            pause() // Pause allows to detect isRunning
                        
            if percentComplete == 0 {
                presentedController?.dismiss(animated: true) // Start the new one
            }
        
        case .changed:
            update(percentComplete + r.incrementToBottom(maxTranslation: maxTranslation))
            
        case .ended, .cancelled:
            if r.isProjectedToDownHalf(maxTranslation: maxTranslation) {
                finish()
            } else {
                cancel()
            }

        case .failed:
            cancel()
            
        default:
            break
        }
    }
    
    var maxTranslation: CGFloat {
        return presentedController?.view.frame.height ?? 0
    }
    
}

private extension UIPanGestureRecognizer {
    func isProjectedToDownHalf(maxTranslation: CGFloat) -> Bool {
        let endLocation = projectedLocation(decelerationRate: .fast)
        let isPresentationCompleted = endLocation.y > maxTranslation / 2
        
        return isPresentationCompleted
    }
    
    func incrementToBottom(maxTranslation: CGFloat) -> CGFloat {
        let translation = self.translation(in: view).y
        setTranslation(.zero, in: nil)
        
        let percentIncrement = translation / maxTranslation
        return percentIncrement
    }
}
