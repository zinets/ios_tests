//
//  MDUKNotificatorFooterView.swift
//
//  Created by Viktor Zinets on 10/4/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class MDUKNotificatorFooterView: UITableViewHeaderFooterView {

    var upgradeButtonAction: (() -> Void)?
    
    @IBOutlet weak var upgradeButton: UIButton! {
        didSet {
            upgradeButton.layer.cornerRadius = 8
        }
    }
    
    @IBAction func dfasd(_ sender: Any) {
        if let block = upgradeButtonAction {
            block()
        }
    }
    
}
