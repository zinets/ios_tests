//
//  NotificatorSingleCell.swift
//  notificationProto
//
//  Created by Viktor Zinets on 10/3/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class NotificatorSingleCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView! {
        didSet {
            avatarView.layer.cornerRadius = 40
        }
    }
    @IBOutlet weak var activityTypeView: UIImageView! {
        didSet {
            activityTypeView.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
