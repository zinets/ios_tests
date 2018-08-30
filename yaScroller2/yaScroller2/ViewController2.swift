//
//  ViewController2.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var activityIndicator: ThreeDotsActivityIndicator!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func startAction(_ sender: Any) {
        activityIndicator.startAnimation()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        activityIndicator.stopAnimation()
    }
    
}
