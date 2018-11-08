//
//  ViewController.swift
//  blindActivityIndicator
//
//  Created by Victor Zinets on 11/6/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BlindRemainingViewDelegate {
    
    func remainingDidEnd(_ sender: Any) {
        print("ALARM!!!")
    }
    

    @IBOutlet weak var activityIndicator: BlindActivityIndicator!
    @IBOutlet weak var activityIndicator2: BlindActivityIndicator2!
    @IBOutlet weak var remainingCounter: BlindRemainingView!
    var avatarView: UIImageView!
    
    var remainTime: TimeInterval = 20;    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarView = UIImageView(image: UIImage(named: "img"))
        self.remainingCounter.embeddedView = avatarView
        self.remainingCounter.overallTime = 5 * 60
        
    }

    @IBAction func startAnimation(_ sender: Any) {
        activityIndicator.startAnimation()
        activityIndicator2.startAnimation()
    }
    
    @IBAction func stopAnimation(_ sender: Any) {
        activityIndicator.stopAnimation()
        activityIndicator2.stopAnimation()
    }
    @IBAction func resetTime(_ sender: Any) {
        remainingCounter.overallTime = 45
    }
    @IBAction func tickTime(_ sender: Any) {
        remainingCounter.stopTimer()
    }
    
    @IBAction func startTimer(_ sender: Any) {
        remainingCounter.startTimer()
    }
    @IBAction func pauseTimer(_ sender: Any) {
        remainingCounter.pauseTimer()
    }
}

