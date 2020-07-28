import UIKit

/*
    чухонская схема, работает, но есть очень большие сомнения, что это не херня - и много "соглашений"
    вообщем приходится делать несколько пассов руками: в презент-делегате того контроллера, КОТОРЫЙ показываем, в методе animationController(forDismissed dismissed: UIViewController) отдается аниматор для dismiss; при этом там может отдаваться 2 аниматора (TODO: доделать норм) - для обычной анимации и для прерываемой (или можно сделать один с настройкой)
    для интерактивной анимации (проверяем interactionInProgress у FullscreenDismissTransition) отдаем (или настраиваем) анимацию и сохраняем ссылку (TODO: weak и прочие фигни посмотреть, чтоб не ретейнилось)
    аниматор использует для перехода "назад" временное вью, которое анимируется из "фулскрина" в фрейм, из которого стартовала анимация перехода в фулскрин; FullscreenDismissTransition обрабатывает рекогнайзер и ему нужна ссылка на то временное вью, чтобы по мере движения перемещать (трансформированное тут) вью по экрану "как в ..."
    когда в любом случае движение заканчиывается - нужно с анимацией вернуть .ident временному вью, чтобы оно естественно (без рывка) перешло в финальный фремй, поределенный в обьекте-аниматоре
    это то, что мне не очень нравится, отдельная анимация тут; было бы больше ума - можно сделать синхронизацию анимации "там" и "тут", мне кажется это можно, но как я не знаю (пока)
    
    анимация dismiss-аниматора - keyframe с 2 фазами: первая фаза на 75% времени сдвиг фрейма вниз, вторая фаза меняет contentMode и фрейм; соотв. в обработке рекогнайзера вычисленное смещение ограничивается 0,75, чтобы при любых маханиях пальцем по экрану отрабатывала только первая фаза анимации; после отпускания пальца (и прогрессе достаточном для завершения действия) срабатывает вторая фаза и фейковая скукоженая картинка улетает "из фулскрина на место" с изменением вписывания .aspectFill
 
 */

class FullscreenDismissTransition: UIPercentDrivenInteractiveTransition {
    
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
            
            var p = min(0.75, progress)
            update(p)
            p = max(0.5, 1 - p)
  
            if let view = (animator as? FullScreenInteractiveDismissAnimator)?.tempView {
                var transform: CGAffineTransform = .identity
                transform = transform.translatedBy(x: translation.x, y: translation.y)
                transform = transform.scaledBy(x: p, y: p)
                
                view.transform = transform
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
                let a = UIViewPropertyAnimator(duration: 0.15, curve: .easeOut)
                a.addAnimations {
                    view.transform = .identity
                }
                a.startAnimation()
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
