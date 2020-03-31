//
//  CPDOwnProfileEditBaseCell.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class CPDOwnProfileEditBaseCell: UITableViewCell, AnyDiffAbleControl {

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
    
    var expanded = false
    
    // MARK: outlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var disclosureView: UIImageView!
    
    func configure(_ item: AnyDiffAble) {
        
    }
}

class CPDOwnProfileEditCell: CPDOwnProfileEditBaseCell {
    override func configure(_ item: AnyDiffAble) {
        print(#function)
    }
}
