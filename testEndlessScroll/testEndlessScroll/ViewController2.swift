//
//  ViewController2.swift
//  testEndlessScroll
//
//  Created by Victor Zinets on 1/17/19.
//  Copyright © 2019 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var tapplRequestsScroller: TapplRequestsList!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resetScroller(_ sender: Any) {
        tapplRequestsScroller.selectedIndex = 0
    }
    
    @IBAction func reloadScroller(_ sender: Any) {
        tapplRequestsScroller.reloadData()
    }
    

}
