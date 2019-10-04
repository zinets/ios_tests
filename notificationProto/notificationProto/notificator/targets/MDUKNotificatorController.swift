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

        let item = NotificationGroupedItem(with: "NotificatorGroupedCell")
        
        let attributedText = self.attributedStringForText(text: "Danielle liked your photo и послала тебе фото своей киски", selected: ["Danielle", "фото"])
        item.notificationText = attributedText
        
        item.notificationAge = "2 days ago"
        item.notificationType = .visitor
        item.placeholder = "notificationMalePlaceholder"
        item.avatarUrl = "https://static-s.aa-cdn.net/img/ios/1173498738/0893b85443c5b797f6926a6565142c4f"
        
        item.counter = 44
        item.expandAction = {
            print(#function)
        }
        
        
        self.datasource.appendSections([.main])
        self.datasource.appendItems([item], toSection: .main)
        
        self.datasource.endUpdates()
    }

    // MARK: appearance -
        
        let compactHeight: CGFloat = 150
        var compactMode: Bool = true {
            didSet {
                guard oldValue != compactMode else {
                    return
                }
                var frame = self.view.frame
                if compactMode {
                    frame.size.height = compactHeight
                } else {
                    frame.size.height = self.view.superview!.bounds.size.height
                }
                
                self.view.frame = frame
                let bgColor = !compactMode ? UIColor.black.withAlphaComponent(0.3) : .clear
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.backgroundColor = bgColor
                }) { (_) in
    //                self.isFooterVisible = !self.compactMode
                    self.isHeaderVisible = !self.compactMode
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                
                
                panRecognizer?.isEnabled = compactMode
            }
        }
}
