//
//  Swipeable.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

// usage: есть протокол Swipeable, которому конформит дефолтной реализацией pan recognizer; поэтому любой вью можно добавить стандартный пан рекогнайзер, все будет работать как обычно - пока в качестве селектора не передать метод из расширения - тогда жесты будут обрабатываться именно как смахивание карточки
// красиво же

protocol Swipeable { }

enum SwipeDirection {
    case decline, accept // предполагая, что вправо - это принять, а влево - отменить
}

// начали смахивание, возюкаем туда-сюда (с прогрессом меньшим 1, т.к. до 1 физически не дотянуться), сбрасываем карточку или отменяем и возвращаем назад; если карточка смахнута, то обязанность делегата обновить "датасорс" и убрать смахнутую карту
protocol SwipeableDelegate: class {
    func didBeginSwipe(view: UIView)
    func didChangeSwipeProgress(view: UIView, progress: CGFloat)
    func didEndSwipe(view: UIView, direction: SwipeDirection)
    func didCancelSwipe(view: UIView)
}

// если вью, к которому присоединен рекогнайзер, конформит SwipeableView, то ему будут слаться события при смахивании
protocol SwipeableView: class {
//    associatedtype P это прикольно но ведет к переизбытку кода там, где можно обойтись
//    var delegate: P? { get set }
    var swipeDelegate: SwipeableDelegate? { get set }
}

@propertyWrapper // немножко понтов
struct Restriction<V: Comparable> {
    var value: V
//    let min: V
//    let max: V
    var range: ClosedRange<V>
    
    init(wrappedValue: V, _ range: ClosedRange<V>) {
        precondition(range.contains(wrappedValue), "Начальное значение выходит за границы!")
        value = wrappedValue
        self.range = range
    }
    
    var wrappedValue: V {
        get {
            value            
        }
        set {
            value = min(range.upperBound, max(newValue, range.lowerBound))
        }
    }
}

protocol OverlayedView: class {
    // пусть вью должно реагировать внешне на свое перемещение при смахивании; если оно конформит этому протоколу, то значит у него есть свойство, которое определяет "непрозрачность" этого дополнительного внешнего вида
    var overlayOpacity: CGFloat { get set }
}

// тут собственно реализация слежения за движенем пальца, ничего делать не нужно, кроме может вынести более цивильно магические цифры, определяющие поведение
extension Swipeable where Self: UIPanGestureRecognizer {
    
    func swipeView() {
        
        guard let view = self.view else { return }
        
        let panGestureTranslation = self.translation(in: view)
        let rotationStrength = min(panGestureTranslation.x / view.frame.width, 0.51)
        
        let maxAngle = CGFloat.pi / 3
        
        switch state {
        case .began:
            view.layer.rasterizationScale = UIScreen.main.scale
            view.layer.shouldRasterize = true
            if let delegate = (view as? SwipeableView)?.swipeDelegate {
                delegate.didBeginSwipe(view: view)
            }
        case .changed:
            let rotationAngle = maxAngle * rotationStrength // фактически некий "радиус" вращения карточки
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, /* ограничение движения по одной оси 0 иначе panGestureTranslation.y*/panGestureTranslation.y, 0)
            view.layer.transform = transform
            if let delegate = (view as? SwipeableView)?.swipeDelegate {
                delegate.didChangeSwipeProgress(view: view, progress: rotationStrength)
            }
        case .ended:
            if abs(rotationStrength) > 0.3 {
                if let delegate = (view as? SwipeableView)?.swipeDelegate {
                    delegate.didEndSwipe(view: view, direction: rotationStrength > 0 ? .accept : .decline)
                } else {
                    // если по какой-то причине некому отреагировать, что мы смахнули карточку - то вернем ее на место
                    view.layer.transform = CATransform3DIdentity
                }
            } else {
                view.layer.transform = CATransform3DIdentity
                if let delegate = (view as? SwipeableView)?.swipeDelegate {
                    delegate.didCancelSwipe(view: view)
                    delegate.didChangeSwipeProgress(view: view, progress: 0)
                }
            }
            view.layer.shouldRasterize = false

        default:
            break
        }
    }

}

extension UIPanGestureRecognizer: Swipeable { }



