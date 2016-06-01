//
//  ViewController.swift
//  FrameworksDemoSwiftApp
//
//  Created by Zinets Victor on 6/1/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

import UIKit
import StaticFramework

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onTap1(sender: AnyObject) {
        label.text = StaticLib.staticMethod();
    }

    @IBAction func onTap2(sender: AnyObject) {
        label.text = StaticLib().instanceMethod(28);
    }
}

