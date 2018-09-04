//
//  IntroCellOther.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class IntroCellOther: UICollectionViewCell, DataAwareCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    func fillWithData(_ data: DataSourceItem) {
        let images = [
            "onboardingIllustration1",
            "onboardingIllustration2",
            "onboardingIllustration3"
        ]
        let titles = [
            "Magic come true ",
            "Express feelings",
            "Chat and have fun!",
            ]
        let texts = [
            "We believe everyone will find a soulmate",
            "Hold the button to express your sympathy",
            "Communicate with people and enjoy",
        ]
        
        if let index = data.payload as? Int {
            imageView.image = UIImage(named: images[index - 1])
            label.text = titles[index - 1]
            label2.text = texts[index - 1]
            
        }
        
        
    }
}
