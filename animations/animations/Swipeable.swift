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
            view.layer.rasterizationScale = UIScreen.main.scale
            view.layer.shouldRasterize = true
            if let delegate = (view as? SwipeableView)?.swipeDelegate {
                delegate.didBeginSwipe()
            }
        case .changed:
            let rotationStrength = min(panGestureTranslation.x / view.frame.width, CGFloat.pi / 4)
            let rotationAngle = CGFloat.pi / 6 * rotationStrength // фактически некий "радиус" вращения карточки
//            print(rotationStrength)
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, /* ограничение движения по одной оси 0 иначе panGestureTranslation.y*/panGestureTranslation.y, 0)
            view.layer.transform = transform
        case .ended:
            let rotationStrength = min(panGestureTranslation.x / view.frame.width, CGFloat.pi / 4)
            
            if abs(rotationStrength) > 0.3 {
                if let delegate = (view as? SwipeableView)?.swipeDelegate {
                    delegate.didEndSwipe(direction: rotationStrength > 0 ? .accept : .decline)
                }
            } else {
                view.layer.transform = CATransform3DIdentity
                if let delegate = (view as? SwipeableView)?.swipeDelegate {
                    delegate.didCancelSwipe()
                }
            }
            view.layer.shouldRasterize = false

        default:
            break
        }
    }

}

extension UIPanGestureRecognizer: Swipeable { }



