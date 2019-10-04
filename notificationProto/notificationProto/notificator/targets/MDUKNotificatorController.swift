//
//  MDUKNotificatorController.swift
//  notificationProto
//
//  Created by Viktor Zinets on 10/4/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class MDUKNotificatorController: NotificatorController {

    override func prepareDatasource() {
        super.prepareDatasource()
        
        self.tableView.register(UINib(nibName: "MDUKNotificatorHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        self.tableView.register(UINib(nibName: "MDUKNotificatorFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Footer")
        
        // test data
        self.datasource.beginUpdates()

        let item = NotificationItem(with: "NotificatorGroupedCell")
        
        let attributedText = self.attributedStringForText(text: "Danielle liked your photo и послала тебе фото своей киски", selected: ["Danielle", "фото"])
        item.notificationText = attributedText
        
        item.notificationAge = "2 days ago"
        item.notificationType = .visitor
        item.placeholder = "notificationMalePlaceholder"
        item.avatarUrl = "https://static-s.aa-cdn.net/img/ios/1173498738/0893b85443c5b797f6926a6565142c4f"
        
        
        
        self.datasource.appendSections([.main])
        self.datasource.appendItems([item], toSection: .main)
        
        self.datasource.endUpdates()
    }

}
