//
//  TapplRequestsListCellCollectionViewCell.swift
//  testEndlessScroll
//
//  Created by Victor Zinets on 1/17/19.
//  Copyright © 2019 Victor Zinets. All rights reserved.
//

import UIKit

class TapplRequestsListCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var heartControl: UIImageView!
    
    var centerPos: CGFloat = 0 {
        didSet {
            let empiricShiftValue = CGFloat(414.0 * 1.74)
            heartControl.transform = CGAffineTransform(translationX: empiricShiftValue * centerPos, y: 0)
        }
    }
}
