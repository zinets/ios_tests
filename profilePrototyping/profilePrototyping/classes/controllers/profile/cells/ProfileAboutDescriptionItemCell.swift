//
//  ProfileAboutDescriptionItemCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class ProfileAboutDescriptionItemCell: ProfileItemCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func fillWithData(_ data: DataSourceItem) {
        if let userInfo = data.payload as? UserInfo {
            descriptionLabel.text = userInfo.aboutDescription
        }
    }

}
