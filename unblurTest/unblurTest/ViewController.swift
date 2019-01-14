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
    @IBOutlet weak var blurredView2: TapplBlurredView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func load(_ sender: Any) {
        blurredView.image = UIImage(named: "salma.jpg")
    }
    @IBAction func load2(_ sender: Any) {
        blurredView.image = UIImage(named: "moloko.jpg")
    }
    @IBAction func update(_ sender: Any) {
        blurredView2.update()
    }
}




class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var testView2: TappleHeartBaseControl!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func testButton(_ sender: Any) {
        
    }
}
