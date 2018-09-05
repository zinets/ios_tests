//
//  ProfileOwnPhotoCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileOwnPhotoItemCell: UITableViewCell, DataAwareCell {
    
    @IBOutlet weak var userAvatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    func fillWithData(_ data: DataSourceItem) {
        if let userInfo = data.payload as? UserInfo {
            if userInfo.photos.isEmpty {
                userNameLabel.isHidden = false
                userNameLabel.text = String(userInfo.screenName.prefix(1)).uppercased()
            } else {
                userNameLabel.isHidden = true
                userAvatarView.image = UIImage(named: userInfo.photos.first!)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userAvatarView.layoutIfNeeded() // пц
        userAvatarView.layer.cornerRadius = userAvatarView.frame.size.height / 2
        userAvatarView.clipsToBounds = true
    }
}
