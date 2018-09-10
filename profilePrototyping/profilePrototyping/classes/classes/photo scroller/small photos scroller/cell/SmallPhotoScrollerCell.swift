//
//  SmallPhotoScrollerCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class SmallPhotoScrollerCell: UICollectionViewCell, DataAwareCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 10
    }

    func fillWithData(_ data: DataSourceItem) {
        if let imageName = data.payload as? String {
            imageView.image = UIImage(named: imageName)
        }
    }
}
