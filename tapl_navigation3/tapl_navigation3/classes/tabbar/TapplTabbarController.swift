//
//  TapplTabbarController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // включение тени (здесб и в навконтроллере!)
        for v in self.view.subviews {
            if v.clipsToBounds {
                v.clipsToBounds = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // для того чтобы таббар не просто скрылся, а и не влиял на автолаяуты, нужно в сториборде у таббара убрать галочку transfucent
//        self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.bounds.size.height / 2)
        // или
//        self.tabBar.frame.origin.y += self.tabBar.frame.size.height
//        self.tabBar.frame.size.height = 0
        // НО! все равно не работает        
    }
    

}
