//
//  TestCell1.swift
//  ios13CollectionTests
//
//  Created by Viktor Zinets on 21.05.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class TestCell1: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        label.text = String(format: "%d : %d", layoutAttributes.indexPath.section, layoutAttributes.indexPath.item)
    }
}

class TestCell2: UICollectionViewCell {

}
