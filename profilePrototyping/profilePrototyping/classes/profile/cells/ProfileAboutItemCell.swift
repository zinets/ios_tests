//
//  ProfileAboutItemCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileAboutItemCell: UITableViewCell, DataAwareCell {

    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    func fillWithData(_ data: DataSourceItem) {
        propertyLabel.text = "Marital status"
        valueLabel.text = "Divorced"
    }

}
