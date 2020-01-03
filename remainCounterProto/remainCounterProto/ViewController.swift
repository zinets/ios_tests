//
//  ViewController.swift
//  remainCounterProto
//
//  Created by Viktor Zinets on 03.01.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var remainCounter: RemainCounterView!
    
    @IBAction func countChanged(_ sender: UISlider) {
        
        remainCounter.count = Int(sender.value)
    }
    
}

