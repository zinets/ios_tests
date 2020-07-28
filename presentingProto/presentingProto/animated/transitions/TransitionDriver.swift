import UIKit

class TransitionDriver: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    var animator: UIViewControllerAnimatedTransitioning?
        
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    func link(to controller: UIViewController) {
        viewController = controller
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        viewController.view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            pause()
            if percentComplete == 0 {
                interactionInProgress = true
                viewController.dismiss(animated: true, completion: nil)
            }
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(min(0.75, progress))
  
            if let view = (animator as? FullScreenInteractiveDismissAnimator)?.tempView {
                let transform: CGAffineTransform = .identity
                view.transform = transform.translatedBy(x: translation.x, y: 0)
            }
        case .cancelled:
            interactionInProgress = false
            
            if let view = (animator as? FullScreenInteractiveDismissAnimator)?.tempView {
                view.transform = .identity
            }
            
            cancel()
        case .ended:
            interactionInProgress = false
            
            if let view = (animator as? FullScreenInteractiveDismissAnimator)?.tempView {
                UIView.animate(withDuration: 0.15) {
                    view.transform = .identity
                }
            }
            
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }

    
}
