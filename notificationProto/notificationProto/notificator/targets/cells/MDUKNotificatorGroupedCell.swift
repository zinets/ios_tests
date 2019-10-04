//
//  NotificatorGroupedCell.swift
//
//  Created by Viktor Zinets on 10/3/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class MDUKNotificatorGroupedCell: MDUKNotificatorSingleCell {
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var counterSite: UIView! {
        didSet {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCounterTap))
            counterSite.addGestureRecognizer(tapRecognizer)
            counterSite.isUserInteractionEnabled = true
        }
    }
    
    // MARK: data -
    override func fillData(_ data: NotificationItem) {
        super.fillData(data)
        if let data = data as? NotificationGroupedItem {
            counterLabel.text = String(data.counter)
            self.expandAction = data.expandAction
        }
    }
    
    // MARK: actions -
    var expandAction: (() -> Void)?
    @objc private func onCounterTap() {
        if let block = self.expandAction {
            block()
        }
    }
}
