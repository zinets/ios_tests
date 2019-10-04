//
//  MDUKNotificatorHeaderView.swift
//  notificationProto
//
//  Created by Viktor Zinets on 10/4/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class MDUKNotificatorHeaderView: UITableViewHeaderFooterView {

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
