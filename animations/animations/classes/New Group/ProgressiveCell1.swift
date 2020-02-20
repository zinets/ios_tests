//
//  ProgressiveCell1.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class ProgressiveCell1: UICollectionViewCell {
    
    @IBOutlet weak var progressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(hue: CGFloat.random(in: 0..<1), saturation: 1, brightness: 1, alpha: 1)
    }
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attrs = layoutAttributes as? CollectionViewProgressLayoutAttributes else { return }
        progressLabel.text = "progress: \(attrs.progress)"
    }
}
