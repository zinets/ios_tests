//
//  IntroPage0Cell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class IntroPage0Cell: UICollectionViewCell, DataAwareCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillWithData(_ data: DataSourceItem) {
        if let index = data.payload as? Int, index == 0 {
            imageView.image = UIImage(named: "onboardingIllustration0")
            label.text = "Express your feelings"
        }
    }
}
