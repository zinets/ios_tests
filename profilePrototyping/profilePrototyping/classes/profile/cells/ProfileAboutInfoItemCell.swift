//
//  ProfileAboutInfoItemCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileAboutInfoItemCell: UITableViewCell, DataAwareCell {

    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var onlineIndicatorView: ProfileOnlineIndicatorView!
    func fillWithData(_ data: DataSourceItem) {
        screenNameLabel.text = "Kurgan Agregat"
        ageLabel.text = "28"
        locationLabel.text = "Chernigov, Ukraine"
        onlineIndicatorView.state = .Online
    }

}
