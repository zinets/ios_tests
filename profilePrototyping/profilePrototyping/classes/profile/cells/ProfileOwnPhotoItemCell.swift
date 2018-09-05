//
//  ProfileOwnPhotoCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileOwnPhotoItemCell: ProfileItemCell {
    
    @IBOutlet weak var userAvatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    private let placeholderColors = [ // это массив цветов для кружоочка аватарки юзера без фото
        UIColor(rgb: 0xbe98fe),
        UIColor(rgb: 0xffdd7d),
        UIColor(rgb: 0xf6affb),
        UIColor(rgb: 0x8cd89a),
        UIColor(rgb: 0x989cfe),
    ]
    
    override func fillWithData(_ data: DataSourceItem) {
        if let userInfo = data.payload as? UserInfo {
            if userInfo.photos.isEmpty {
                userNameLabel.isHidden = false
                let firstLetter = String(userInfo.screenName.uppercased().prefix(1))
                userNameLabel.text = firstLetter
                
                userAvatarView.backgroundColor = placeholderColors[firstLetter.hashValue % placeholderColors.count]
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
