//
//  NotificatorHeaderView.swift
//  test1
//
//  Created by Viktor Zinets on 10/2/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class NotificatorHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var lessButton: UIButton! {
        didSet {
            lessButton.layer.cornerRadius = 8
        }
    }
    
    @IBAction func ert(_ sender: Any) {
        print(sender)
    }
    
}

class NotificatorFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var upgradeButton: UIButton! {
        didSet {
            upgradeButton.layer.cornerRadius = 8
        }
    }
    
    @IBAction func dfasd(_ sender: Any) {
        print(sender)
    }
    
}
