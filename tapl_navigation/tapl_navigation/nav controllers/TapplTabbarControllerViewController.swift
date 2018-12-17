//
//  TapplTabbarControllerViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/17/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplTabbarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        // для того чтобы таббар не просто скрылся, а и не влиял на автолаяуты, нужно в сториборде у таббара убрать галочку transfucent
        self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.bounds.size.height)
    }
    
 
}
