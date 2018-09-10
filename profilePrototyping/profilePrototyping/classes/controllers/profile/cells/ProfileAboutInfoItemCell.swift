//
//  ProfileAboutInfoItemCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class ProfileAboutInfoItemCell: UITableViewCell, DataAwareCell {

    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var onlineIndicatorView: ProfileOnlineIndicatorView!
    func fillWithData(_ data: DataSourceItem) {
        if let userInfo = data.payload as? UserInfo {
            screenNameLabel.text = userInfo.screenName
            ageLabel.text = String(userInfo.age)
            locationLabel.text = userInfo.location
            onlineIndicatorView.state = userInfo.onlineStatus
        }
    }

}
