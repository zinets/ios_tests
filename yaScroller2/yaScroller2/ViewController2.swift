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

        activityIndicator.dotSize = CGSize(width: 10, height: 10)
        activityIndicator.dotSpace = 10
        activityIndicator.dotsCount = 5
        activityIndicator.dotColor = UIColor.blue
        activityIndicator.activeDotColor = UIColor.red
        activityIndicator.animationDuration = 3
    }

    @IBAction func startAction(_ sender: Any) {
        activityIndicator.startAnimation()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        activityIndicator.stopAnimation()
    }
    
}
