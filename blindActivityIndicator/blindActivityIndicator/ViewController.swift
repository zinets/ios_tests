//
//  ViewController.swift
//  blindActivityIndicator
//
//  Created by Victor Zinets on 11/6/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: BlindActivityIndicator!
    @IBOutlet weak var activityIndicator2: BlindActivityIndicator2!
    @IBOutlet weak var remainingCounter: BlindRemainingView!
    var avatarView: UIImageView!
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
}

