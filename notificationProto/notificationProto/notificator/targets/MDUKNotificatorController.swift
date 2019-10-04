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
//        self.datasource.beginUpdates()
//
//        let item = NotificationGroupedItem(with: "NotificatorGroupedCell")
//
//        let attributedText = self.attributedStringForText(text: "Danielle liked your photo и послала тебе фото своей киски", selected: ["Danielle", "фото"])
//        item.notificationText = attributedText
//
//        item.notificationAge = "2 days ago"
//        item.notificationType = .visitor
//        item.placeholder = "notificationMalePlaceholder"
//        item.avatarUrl = "https://static-s.aa-cdn.net/img/ios/1173498738/0893b85443c5b797f6926a6565142c4f"
//
//        item.counter = 44
//        item.expandAction = {
//            print(#function)
//        }
//
//
//        self.datasource.appendSections([.main])
//        self.datasource.appendItems([item], toSection: .main)
//
//        self.datasource.endUpdates()
    }
    
    override var notifications: [NotificationData]! {
        didSet {
            guard notifications.count > 0 else {
                fatalError("Что происходит? какого хера показываем 0 нотификаций?")
            }
            var items: [NotificationItem]
            if self.compactMode && notifications.count > 1 { // берем первую нотификацию, показываем ее и кол-во вообще
                let groupedItem = NotificationGroupedItem(with: "NotificatorGroupedCell")
                let firstNotification = notifications.first!
                
                groupedItem.counter = notifications.count
                groupedItem.expandAction = { [weak self] in
                    print(#function)
                    self?.compactMode = !self!.compactMode
                }
                groupedItem.notificationText = firstNotification.notificationText
                groupedItem.notificationAge = firstNotification.notificationAge
                groupedItem.notificationType = firstNotification.notificationType
                groupedItem.avatarUrl = firstNotification.avatarUrl
                groupedItem.placeholder = firstNotification.placeholder
                
                items = [groupedItem]
            } else {
                items = notifications.map({ (data) -> NotificationItem in
                    let item = NotificationItem(with: "NotificatorSingleCell")
                    item.notificationText = data.notificationText
                    item.notificationAge = data.notificationAge
                    item.notificationType = data.notificationType
                    item.avatarUrl = data.avatarUrl
                    item.placeholder = data.placeholder
                    return item
                })
            }
            
            self.datasource.beginUpdates()
            
            self.datasource.appendSections([.main])
            self.datasource.appendItems(items, toSection: .main)
            
            self.datasource.endUpdates()
        }
    }

    // MARK: appearance -
    
    private let compactHeight: CGFloat = 150
    private var compactMode: Bool = true {
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
    
    override func prepareCell(_ cell: UITableViewCell, _ item: NotificationItem) -> Void {
        if let cell = cell as? MDUKNotificatorGroupedCell {
            cell.fillData(item)
        }
    }

}
