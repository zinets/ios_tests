//
//  NotificatorGroupedCell.swift
//  notificationProto
//
//  Created by Viktor Zinets on 10/3/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit

class NotificatorGroupedCell: UITableViewCell {

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
    
    @IBOutlet weak var counterLabel: UILabel! {
        didSet {
            counterLabel.text = "1488"
        }
    }
    
    // MARK: overrides -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
}
