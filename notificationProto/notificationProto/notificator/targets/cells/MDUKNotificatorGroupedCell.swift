//
//  NotificatorGroupedCell.swift
//  notificationProto
//
//  Created by Viktor Zinets on 10/3/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class MDUKNotificatorGroupedCell: MDUKNotificatorSingleCell {
    
    @IBOutlet weak var counterLabel: UILabel!
    
    // MARK: data -
    override func fillData(_ data: NotificationItem) {
        super.fillData(data)
        
        counterLabel.text = String(data.counter)
    }
}
