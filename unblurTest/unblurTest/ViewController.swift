//
//  ViewController.swift
//  unblurTest
//
//  Created by Victor Zinets on 1/11/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var blurredView: TapplBlurredImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func load(_ sender: Any) {
        blurredView.image = UIImage(named: "salma.jpg")
    }
    @IBAction func load2(_ sender: Any) {
        blurredView.image = UIImage(named: "moloko.jpg")
    }
}

