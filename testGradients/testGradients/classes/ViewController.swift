//
//  ViewController.swift
//  testGradients
//
//  Created by Zinets Victor on 10/22/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animatedGradientPanel: AnimatedGradientPanel!
    @IBAction func changeColors(_ sender: Any) {
        let newColors = [
            UIColor.yellow, UIColor.magenta, UIColor.red
        ]
        
        animatedGradientPanel.colors = newColors
        
    }
}
