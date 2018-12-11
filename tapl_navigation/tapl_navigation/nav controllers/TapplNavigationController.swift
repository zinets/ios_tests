//
//  TapplNavigationController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/11/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplNavigationController: UINavigationController {
    
    lazy var phantomView: UIView = {
        let frame = CGRect(x: 20, y: 0, width: self.view.bounds.size.width - 40, height: self.view.bounds.size.height)
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.brown
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        
        self.view.insertSubview(phantomView, at: 0)
    }
   

}
