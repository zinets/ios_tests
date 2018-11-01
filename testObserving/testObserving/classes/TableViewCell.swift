//
//  TableViewCell.swift
//  testObserving
//
//  Created by Victor Zinets on 11/1/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var label: UILabel!
}
