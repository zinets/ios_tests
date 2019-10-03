//
//  ViewController.swift
//  notificationProto
//
//  Created by Viktor Zinets on 10/3/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showNotificator(_ sender: Any) {
        guard let ctrl = UIStoryboard(name: "Notificator", bundle: nil).instantiateInitialViewController() else {
            return
        }
        
        self.addChild(ctrl)
        self.view.addSubview(ctrl.view)
        ctrl.didMove(toParent: self)
    }
    
}

