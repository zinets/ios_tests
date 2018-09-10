//
//  ProfileAboutSubtitleItemCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class ProfileAboutSubtitleItemCell: UITableViewCell, DataAwareCell {

    @IBOutlet weak var titleLabel: UILabel!
    func fillWithData(_ data: DataSourceItem) {
        if let titleText = data.payload as? String {
            titleLabel.text = titleText
        }
    }
}
