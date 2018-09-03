//
//  FavoritesListCell.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import TNURLImageView

class FavoritesListCell: UITableViewCell {

    @IBOutlet weak var userAvatarView: TNImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    func fillData(_ data: DataSourceItem) {

    }
}
