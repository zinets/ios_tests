//
//  CPDOwnProfileEditBaseCell.swift
//  protoProfileEdits
//
//  Created by Viktor Zinets on 31.03.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class OwnProfileEditorBaseCell: UITableViewCell, AnyDiffAbleControl {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        
        self.dividerView.backgroundColor = selected ? activeDividerColor : inactiveDividerColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
           
    // MARK: outlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var disclosureView: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    
    // допустим что эти ячейки будут использоваться не только в купеде; они надизайнятся в отдельном сториборде или ксибе, но класс можео использовать общий? отличия настроить в наследнике не получится (или я тупой и не знаю как), поэтому отличия нужно сделать свойствами
    @IBInspectable var activeDividerColor: UIColor = UIColor(red: 0.008, green: 0.569, blue: 0.953, alpha: 1)
    @IBInspectable var inactiveDividerColor: UIColor = UIColor(red: 0.941, green: 0.953, blue: 0.961, alpha: 1)
    
    var changeAction: ((Any?) -> ())?
    func configure(_ item: AnyDiffAble) {
        if let item = item.payload as? CPDOwnProfileEditorItem {
            self.titleLabel.text = item.title
            
            self.valueLabel.isEnabled = item.editable
            self.disclosureView.isHidden = !item.editable
            
            self.changeAction = item.onDataChange
        }
    }
}
