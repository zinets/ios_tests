//
//  IntroPageXCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

import CollectionControls

class IntroPageXCell: UICollectionViewCell, DataAwareCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillWithData(_ data: DataSourceItem) {
        let images = ["", "onboardingIllustration1", "onboardingIllustration2", "onboardingIllustration3"]
        let texts = ["", "text1", "text2", "text3"]
        if let index = data.payload as? Int {
            
            imageView.image = UIImage(named: images[index])
            label.text = texts[index]
        }
    }
}
