import UIKit

class TransitionDriver: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    func link(to controller: UIViewController) {
        viewController = controller
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = //UIScreenEdgePanGestureRecognizer(target: self,
            UIPanGestureRecognizer(target: self,
                                   action: #selector(handleGesture(_:)))
        //    gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        // 1
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        // 2
        case .began:
            pause()
            if percentComplete == 0 {
                interactionInProgress = true
                viewController.dismiss(animated: true, completion: nil)
            }
        // 3
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        // 4
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        // 5
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
    
    @objc private func handle(recognizer: UIPanGestureRecognizer) {
        
        guard let view = recognizer.view else { return }
        let maxTranslation = viewController?.view.frame.height ?? 0
        let translation = recognizer.translation(in: view).y
        
        switch recognizer.state {
        case .began:
            pause()
            if percentComplete == 0 {
                viewController?.dismiss(animated: true) // Start the new one
            }
        case .changed:
            recognizer.setTranslation(.zero, in: nil)
            let percentIncrement = translation / maxTranslation
            let value = percentComplete + percentIncrement
            print(value)
            update(value)
        case .ended, .cancelled:
            var progress = (translation / 200)
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            if progress > 0.5 {
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
