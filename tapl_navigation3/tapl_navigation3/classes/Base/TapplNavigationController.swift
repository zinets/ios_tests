//
//  TapplNavigationController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // включение тени (здесь и в таббар контроллере)
        for v in self.view.subviews {
            print("view: \(v)")
            if v.clipsToBounds {
                v.clipsToBounds = false
            }
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}
