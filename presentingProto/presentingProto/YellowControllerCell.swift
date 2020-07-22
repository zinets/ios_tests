//
//  YellowControllerCell.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import DiffAble

struct ContentItem: Item  {
    var cellReuseId: String = YellowControllerCell.reusableIdentifier
    var text: String
}

class YellowControllerCell: UICollectionViewCell, AnyDiffAbleControl {
    
    @IBOutlet weak var contentLabel: UILabel!
    func configure(_ item: AnyDiffAble) {
        if let item = item.payload as? ContentItem {
            contentLabel.text = item.text
        }
    }
}
