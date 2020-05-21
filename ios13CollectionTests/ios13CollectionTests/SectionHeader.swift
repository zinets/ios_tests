//
//  SectionHeader.swift
//  ios13CollectionTests
//
//  Created by Viktor Zinets on 21.05.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.text = "Section 3"
        }
    }
}
