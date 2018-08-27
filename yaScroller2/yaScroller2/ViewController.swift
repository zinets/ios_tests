//
//  ViewController.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/27/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func test1(_ sender: Any) {
        
        let testDatasource = SectionDatasource()
        
        testDatasource.items = ["1", "2", "3"]
        
        testDatasource.items = ["4", "1", "2"]
        
        
        
    }
    
    
}

