//
//  NotificatiorView.swift
//  test1
//
//  Created by Viktor Zinets on 10/1/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class NotificatiorView: UIView {
    
    @IBOutlet
    var containerView: UIView?
   
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let container = self.containerView {
            let res = container.frame.contains(point)
            return res
        }
        
        return super.point(inside: point, with: event)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
//        let r = UIPanGestureRecognizer(target: self, action: #selector(onPan(sender:)))
//        self.addGestureRecognizer(r)
    }
    
    private var isDirectionVertical: Bool?
    @objc func onPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let pt = sender.translation(in: self)
            if isDirectionVertical == nil {
                isDirectionVertical = abs(pt.y) > abs(pt.x)
            }
            if isDirectionVertical! {
                self.transform = CGAffineTransform(translationX: 0, y: pt.y)
            } else {
                self.transform = CGAffineTransform(translationX: pt.x, y: 0)
            }
        case .ended:
            isDirectionVertical = nil
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        default:
            break
        }
    }

}
