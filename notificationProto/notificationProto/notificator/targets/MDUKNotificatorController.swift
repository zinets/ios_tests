//
//  MDUKNotificatorController.swift
//
//  Created by Viktor Zinets on 10/4/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class MDUKNotificatorController: NotificatorController {

    override func prepareDatasource() {
        super.prepareDatasource()
        
        self.datasource.defaultInsertAnimation = .top
        self.datasource.defaultDeleteAnimation = .top
        self.datasource.defaultUpdateAnimation = .fade
        
        self.tableView.register(UINib(nibName: "MDUKNotificatorHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        self.tableView.register(UINib(nibName: "MDUKNotificatorFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Footer")
    }
    
    override var notifications: [NotificationData]! {
        didSet {
//            guard notifications.count > 0 else {
//                fatalError("Что происходит? какого хера показываем 0 нотификаций?")
//            }
            self.updateNotifications()
        }
    }
    
    private func updateNotifications() {
        var items: [NotificationItem]
        if self.compactMode && notifications.count > 1 { // берем первую нотификацию, показываем ее и кол-во вообще
            let groupedItem = NotificationGroupedItem(with: "NotificatorGroupedCell")
            let firstNotification = notifications.first!
            
            groupedItem.counter = notifications.count
            groupedItem.expandAction = { [weak self] in                
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
        
        
        
        let cells = self.tableView.visibleCells
        if let cell = cells.first, self.compactMode {
            var frame = self.view.frame
            frame.size.height = cell.bounds.height + 44 // TODO: 44 от фонаря, я не знаю как правильно определять размер в компактном состоянии
            self.view.frame = frame
        }
        
        if self.compactMode {
            self.startTimer()
        } else {
            self.stopTimer()
        }
    }
    
    override func closeAction(_ animated: Bool = false) {
        self.notifications = [] // ну такое, но работает; смысл в том, что убираем вью, но при этом убираем нотификации - они анимируются отдельно, в этом дизайне - уезжают вверх
        // чото очкую, может в реальных условиях что-то пойти не так? вполне себе
        super.closeAction(animated)
    }

    // MARK: appearance -
    
    private let compactHeight: CGFloat = 150
    private var compactMode: Bool = true {
        didSet {
            var frame = self.view.frame
            if compactMode {
                frame.size.height = compactHeight
            } else {
                frame.size.height = self.view.superview!.bounds.size.height
            }
            self.view.frame = frame
            
            guard oldValue != compactMode else {
                return
            }
            
            let bgColor = !compactMode ? UIColor.black.withAlphaComponent(0.3) : .clear
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = bgColor
            }) { (_) in
                self.isHeaderVisible = !self.compactMode
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            
            panRecognizer?.isEnabled = compactMode
            
            self.updateNotifications()
        }
    }
    
    override func prepareCell(_ cell: UITableViewCell, _ item: NotificationItem) {
        if let cell = cell as? MDUKNotificatorGroupedCell {
            cell.fillData(item)
        } else if let cell = cell as? MDUKNotificatorSingleCell {
            cell.fillData(item)
        }
    }

}

// MARK:  -

extension MDUKNotificatorController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = super.tableView(tableView, viewForHeaderInSection: section)
        if let header = header as? MDUKNotificatorHeaderView {
            header.lessButtonAction = { [weak self] in
                self?.compactMode = true
            }
            header.clearButtonAction = { [weak self] in
                self?.closeAction(true)
            }
        }
        return header
    }
    
}
