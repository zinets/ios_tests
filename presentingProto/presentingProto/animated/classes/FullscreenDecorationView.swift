//
//  FullscreenDecorationView.swift
//  MatureDating
//
//  Created by Victor Zinets on 8/8/19.
//  Copyright © 2019 Together Networks. All rights reserved.
//

import UIKit

/// это вью, которое я буду использовать при настройке фулскрина - дизайню в ИБ вью (от этого вью), раскладываю на нем кнопки, этот класс будет следить, чтобы субконтролы работали, но снизу коллекция не игнорировалась
class FullscreenDecorationView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard view is UIControl else {
            return nil
        }
        
        return view
    }

}
