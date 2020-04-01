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
        
        self.dividerView.backgroundColor = selected ? activeDividerColor : inactiveDividerColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    private let activeDividerColor = UIColor(red: 0.008, green: 0.569, blue: 0.953, alpha: 1)
    private let inactiveDividerColor = UIColor(red: 0.941, green: 0.953, blue: 0.961, alpha: 1)
       
    // MARK: outlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var disclosureView: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    
    var changeAction: (() -> ())?
    func configure(_ item: AnyDiffAble) {
        if let item = item.payload as? CPDOwnProfileEditorItem {
            self.titleLabel.text = item.title
            self.valueLabel.text = item.value
            
            self.valueLabel.isEnabled = item.editable
            self.disclosureView.isHidden = !item.editable
            
            self.changeAction = item.onDataChange
        }
    }
}
