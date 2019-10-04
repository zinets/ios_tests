//
//  NotificatorSingleCell.swift
//  notificationProto
//
//  Created by Viktor Zinets on 10/3/19.
//  Copyright © 2019 Viktor Zinets. All rights reserved.
//

import UIKit
import TNURLImageView

class MDUKNotificatorSingleCell: UITableViewCell {

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

    // MARK: data -
    func fillData(_ data: NotificationItem) {
        self.notificationTextLabel.attributedText = data.notificationText
        self.notificationTimeLabel.text = data.notificationAge
        
        let image = UIImage(named: data.notificationType.imageName)
        self.activityTypeView.image = image
        self.activityTypeView.backgroundColor = .red // TODO: взять hex из notificationType
        
        if let placeholder = data.placeholder, let placeholderImage = UIImage(named: placeholder) {
            self.avatarView.image = placeholderImage
        }
        
        if let avatar = data.avatarUrl {
            let source = TNRemoteResource.with(avatar)
            TNPhotoManager.shared().loadResource(from: source) { [weak self] (image, _) in
                self?.avatarView.image = image
            }
        }
    }
}
