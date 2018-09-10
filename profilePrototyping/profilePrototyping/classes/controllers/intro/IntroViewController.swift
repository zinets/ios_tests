//
//  IntroViewController.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class IntroViewController: UIViewController {

    @IBOutlet weak var introScroller: IntroScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var items = [DataSourceItem]()
        
        var item = DataSourceItem("IntroPage0")
        item.payload = 0
        items.append(item)
        item = DataSourceItem("IntroPageX")
        item.payload = 1
        items.append(item)
        item = DataSourceItem("IntroPageX")
        item.payload = 2
        items.append(item)
        item = DataSourceItem("IntroPageX")
        item.payload = 3
        items.append(item)
        
        introScroller.collectionView.backgroundColor = UIColor.clear
        introScroller.items = items
    }

}
