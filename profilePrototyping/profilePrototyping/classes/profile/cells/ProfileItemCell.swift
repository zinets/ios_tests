//
//  ProfileItemCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileItemCell: UITableViewCell, DataAwareCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    func fillWithData(_ data: DataSourceItem) {
        // to nothing..
    }

}
