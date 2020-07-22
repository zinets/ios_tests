//
//  TransitionDriver.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//
import UIKit

class TransitionDriver: UIPercentDrivenInteractiveTransition {
        
    func link(to controller: UIViewController) {
        presentedController = controller
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        presentedController?.view.addGestureRecognizer(panRecognizer!)
    }
    
    private weak var presentedController: UIViewController?
    private var panRecognizer: UIPanGestureRecognizer?
        
    override var wantsInteractiveStart: Bool {
        get {
            let gestureIsActive = panRecognizer?.state == .began
            return gestureIsActive
        }
        
        set { }
    }
    
    @objc private func handle(recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else { return }
        let maxTranslation = presentedController?.view.frame.height ?? 0
        
        switch recognizer.state {
        case .began:
            pause() // Pause allows to detect isRunning
                        
            if percentComplete == 0 {
                presentedController?.dismiss(animated: true) // Start the new one
            }
        case .changed:
            let translation = recognizer.translation(in: view).y
            recognizer.setTranslation(.zero, in: nil)
            let percentIncrement = translation / maxTranslation
            
            update(percentComplete + percentIncrement)
        case .ended, .cancelled:
            let endLocation = recognizer.projectedLocation(decelerationRate: .fast)
            let isPresentationCompleted = endLocation.y > maxTranslation / 2
            
            if isPresentationCompleted {
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
}
