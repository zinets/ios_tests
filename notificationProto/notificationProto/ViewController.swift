//
//  ViewController.swift
//  notificationProto
//
//  Created by Viktor Zinets on 10/3/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showNotificator(_ sender: Any) {
        guard let ctrl = UIStoryboard(name: "MDUKNotificator", bundle: nil).instantiateInitialViewController() as? NotificatorController else {
            return
        }
        
        self.addChild(ctrl)
        let frame = CGRect(x: 0, y: 0, width: 414, height: 350)
        ctrl.view.frame = frame
        self.view.addSubview(ctrl.view)
        ctrl.didMove(toParent: self)
        
        let attributedText = ctrl.attributedStringWithBoldSelection(text: "Danielle liked your photo и послала тебе фото своей киски", selected: ["Danielle", "фото"])
        
        let item1 = NotificationData(
            notificationType: .photo,
            notificationText: attributedText,
            notificationAge: "5 minutes ago",
            avatarUrl: "https://static-s.aa-cdn.net/img/ios/1173498738/0893b85443c5b797f6926a6565142c4f",
            placeholder: "notificationMalePlaceholder"
        )
        let item2 = NotificationData(
            notificationType: .visitor,
            notificationText: attributedText,
            notificationAge: "5 minutes ago",
            avatarUrl: "https://static-s.aa-cdn.net/img/ios/1173498738/0893b85443c5b797f6926a6565142c4f",
            placeholder: "notificationMalePlaceholder"
        )
        ctrl.notifications = [item1, item2]

    }
    
    @IBAction func test(_ sender: Any) {
        print(sender)
    }
}

