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
        var data: [TapplRequestsListDatasourceItem] = []
        for x in 0..<6 {
            let screenName = "name \(x)" // used as payload
            let item = TapplRequestsListDatasourceItem("TapplRequestCellId", payload: screenName)
            
            item.screenName = screenName
            item.imageName = "image_\(x)"
            item.heartName = "heart_\(Int.random(in: 0..<3))"
            data.append(item)
        }
        tapplRequestsScroller.data = data
    }
    
    @IBAction func deleteSelected(_ sender: Any) {
//        let selectedIndex = tapplRequestsScroller.selectedIndex
//        tapplRequestsScroller.data.remove(at: selectedIndex)
        tapplRequestsScroller.removeSelected()
    }
    
}
