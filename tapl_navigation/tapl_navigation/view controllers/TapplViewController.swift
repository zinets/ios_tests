//
//  TapplViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private let item1: UIBarButtonItem = {
        let i = UIBarButtonItem(title: "item1", style: UIBarButtonItem.Style.plain, target: self, action: #selector(item1tap))
        return i
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = item1
    }
    
    @objc func item1tap() {
        print("!!")
    }
}
