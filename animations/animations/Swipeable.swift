//
//  Swipeable.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

protocol Swipeable { }

enum SwipeDirection {
    case decline, accept // предполагая, что вправо - это принять, а влево - отменить
}

protocol SwipeableDelegate: class {

    // TODO: параметры фукций
    func didBeginSwipe()
    func didEndSwipe(direction: SwipeDirection)
    func didCancelSwipe()
}

protocol SwipeableView: class {
//    associatedtype P это прикольно но ведет к переизбытку кода там, где можно обойтись
//    var delegate: P? { get set }
    var swipeDelegate: SwipeableDelegate? { get set }
}

extension Swipeable where Self: UIPanGestureRecognizer {
    
    func swipeView() {
        
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
            if let delegate = (view as? SwipeableView)?.swipeDelegate {
                delegate.didBeginSwipe()
            }
        case .changed:
            let rotationStrength = min(panGestureTranslation.x / view.frame.width, CGFloat.pi / 4)
            let rotationAngle = CGFloat.pi / 60 * rotationStrength // фактически некий "радиус" вращения карточки
//            print(rotationStrength)
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, /* ограничение движения по одной оси 0 иначе panGestureTranslation.y*/panGestureTranslation.y, 0)
            view.layer.transform = transform
        case .ended:
            let rotationStrength = min(panGestureTranslation.x / view.frame.width, CGFloat.pi / 4)
            
            view.layer.shouldRasterize = false
            
            if abs(rotationStrength) > 0.3 {
                if let delegate = (view as? SwipeableView)?.swipeDelegate {
                    delegate.didEndSwipe(direction: rotationStrength > 0 ? .accept : .decline)
                }
            } else {
                if let delegate = (view as? SwipeableView)?.swipeDelegate {
                    delegate.didCancelSwipe()
                }
            }
            view.layer.transform = CATransform3DIdentity
        default:
            break
        }
    }

}

extension UIPanGestureRecognizer: Swipeable { }



