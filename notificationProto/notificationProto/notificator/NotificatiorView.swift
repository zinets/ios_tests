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
        if let container = self.containerView as? UITableView {
            let pt = self.convert(point, to: container)
            let indexPath = container.indexPathForRow(at: pt)

            return indexPath != nil
        }
        
        return super.point(inside: point, with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let container = self.containerView as? UITableView {
            let pt = self.convert(point, to: container)
            if let indexPath = container.indexPathForRow(at: pt), let cell = container.cellForRow(at: indexPath) {
                return cell
            }
        }
        
        let view = super.hitTest(point, with: event)
        return view
    }

}
