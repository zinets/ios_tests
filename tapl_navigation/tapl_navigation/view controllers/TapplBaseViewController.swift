//
//  TapplViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController: UIViewController {
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private var underliedLayer: TapplBaseViewLayer = {
        let layer = TapplBaseViewLayer()
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        underliedLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(underliedLayer, at: 0)        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        underliedLayer.frame = self.view.bounds
    }
    
    // MARK: navigation
    
    @IBAction func navButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1: print("do search")
        case 2: print("do messages")
        case 3: print("do activities")
        case 4: print("do profile")
        default: break;
        }
    }
    
    
    
}
