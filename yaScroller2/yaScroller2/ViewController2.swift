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
    
    @IBOutlet weak var stopButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        activityIndicator.dotSize = CGSize(width: 10, height: 10)
//        activityIndicator.dotSpace = 10
//        activityIndicator.dotsCount = 5
//        activityIndicator.dotColor = UIColor.blue
//        activityIndicator.activeDotColor = UIColor.red
//        activityIndicator.animationDuration = 3
        
        let activity2 = ThreeDotsActivityIndicator()
//        activity2.sizeToFit()
        activity2.center = CGPoint(x: stopButton.bounds.size.width / 2, y: stopButton.bounds.size.height / 2)
//        activity2.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        stopButton.addSubview(activity2)
        activity2.startAnimation()
    }

    @IBAction func startAction(_ sender: Any) {
        activityIndicator.startAnimation()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        activityIndicator.stopAnimation()
    }
    
}
