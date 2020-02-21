//
//  Swipeable.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

protocol Swipeable { }

extension Swipeable where Self: UIPanGestureRecognizer {
    
    func swipeView() {
        
        // управление вью
//        switch state {
//        case .changed:
//            let translation = self.translation(in: view.superview)
//            view.transform = transform(view: view, for: translation)
//        case .ended:
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [], animations: {
//                view.transform = .identity
//            }, completion: nil)
//
//        default:
//            break
//        }
//
//        private func transform(view: UIView, for translation: CGPoint) -> CGAffineTransform {
//
//            let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
//            // знак определяет "центр" вращения - "-" значит центр сверху, "+" - внизу
//            let rotation = -sin(translation.x / (view.frame.width * 4.0))
//            return moveBy.rotated(by: rotation)
//        }
        
        // управление слоем
        guard let view = self.view else { return }
        let panGestureTranslation = self.translation(in: view)
        switch state {
        case .began:
            let initialTouchPoint = self.location(in: view)
            let newAnchorPoint = CGPoint(x: initialTouchPoint.x / view.bounds.width, y: initialTouchPoint.y / view.bounds.height)
            let oldPosition = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
            let newPosition = CGPoint(x: view.bounds.size.width * newAnchorPoint.x, y: view.bounds.size.height * newAnchorPoint.y)
            view.layer.anchorPoint = newAnchorPoint
            view.layer.position = CGPoint(x: view.layer.position.x - oldPosition.x + newPosition.x, y: view.layer.position.y - oldPosition.y + newPosition.y)

            
            view.layer.rasterizationScale = UIScreen.main.scale
            view.layer.shouldRasterize = true
//            delegate?.didBeginSwipe(onView: self)
        case .changed:
            let rotationStrength = min(panGestureTranslation.x / view.frame.width, CGFloat.pi / 4)
            let rotationAngle = CGFloat.pi / 60 * rotationStrength // фактически некий "радиус" вращения карточки
            print(rotationStrength)
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, /* ограничение движения по одной оси 0 иначе panGestureTranslation.y*/panGestureTranslation.y, 0)
            view.layer.transform = transform
        case .ended:
            let rotationStrength = min(panGestureTranslation.x / view.frame.width, CGFloat.pi / 4)
            
            view.layer.shouldRasterize = false
            
            if abs(rotationStrength) > 0.3 {
//              self.delegate?.didEndSwipe(onView: self)
                // тут анимация улетания
            } else {
//              self.delegate?.didCancelSwipe(onView: self)
                
                view.layer.transform = CATransform3DIdentity
            }
        default:
            break
        }
    }

}

extension UIPanGestureRecognizer: Swipeable { }

