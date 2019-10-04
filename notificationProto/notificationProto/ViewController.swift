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
        guard let ctrl = UIStoryboard(name: "MDUKNotificator", bundle: nil).instantiateInitialViewController() else {
            return
        }
        
        self.addChild(ctrl)
        
        let frame = CGRect(x: 0, y: 0, width: 414, height: 350)
        ctrl.view.frame = frame
        self.view.addSubview(ctrl.view)
        ctrl.didMove(toParent: self)
    }
    
    @IBAction func test(_ sender: Any) {
        print(sender)
    }
}

