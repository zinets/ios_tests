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
        remainTime = 20
        remainingCounter.remainingTime = remainTime
        remainingCounter.startTimer()
    }
    @IBAction func tickTime(_ sender: Any) {
        remainTime -= 1
        remainingCounter.remainingTime = remainTime
    }
}

