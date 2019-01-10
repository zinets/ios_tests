//
//  ViewController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

extension CGFloat {
    func inRads() -> CGFloat {
        return self * .pi / 180.0
    }
}

extension Int {
    func inRads() -> CGFloat {
        return CGFloat(self) * .pi / 180.0
    }
}



class ViewController: UIViewController {

    @IBOutlet var subScrollers: [TapplInfiniteOnboardingScroller]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infiniteScrollersSite.transform = CGAffineTransform(rotationAngle: 50.inRads())
    }

    @IBOutlet weak var infiniteScrollersSite: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var direction = false
        for scroller in subScrollers {
            scroller.startAnimation(direction)
            direction = !direction
        }
    }

}

