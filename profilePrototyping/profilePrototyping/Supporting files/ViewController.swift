//
//  ViewController.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func showProfile(_ sender: Any) {
        if let ctrl = UIStoryboard.init(name: "Profile", bundle: nil).instantiateInitialViewController() {
            self.show(ctrl, sender: nil)
        }
        
    }
    
    @IBOutlet weak var testView: UIView!
    
    @IBAction func testAnimation(_ sender: UIButton) {
        
    }
}

