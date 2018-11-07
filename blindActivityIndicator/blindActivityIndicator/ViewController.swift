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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startAnimation(_ sender: Any) {
        activityIndicator.startAnimation()        
    }
    
    @IBAction func stopAnimation(_ sender: Any) {
        activityIndicator.stopAnimation()
    }
}

