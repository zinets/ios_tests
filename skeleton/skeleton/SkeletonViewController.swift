//
//  ViewController.swift
//  skeleton
//
//  Created by Viktor Zinets on 25.05.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class SkeletonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    

    @IBAction func doAnimation(_ sender: Any) {
        let animator = SkeletonAnimator()
        animator.beginSkeletAnimation(for: self.view)
//        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { (_) in
//            animator.stopAnimation()
//        }
    }
    
}

