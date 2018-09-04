//
//  ProfileAboutDescriptionItemCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileAboutDescriptionItemCell: UITableViewCell, DataAwareCell{

    @IBOutlet weak var descriptionLabel: UILabel!
    func fillWithData(_ data: DataSourceItem) {
        descriptionLabel.text = "I am a 29 years old Shortie (just under 5 foot). Looking for passion and romance, lots of laughs and good conversation. А еще я люблю бухать"
    }

}
