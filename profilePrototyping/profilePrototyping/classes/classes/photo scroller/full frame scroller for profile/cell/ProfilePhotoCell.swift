//
//  ProfilePhotoCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class ProfilePhotoCell: UICollectionViewCell, DataAwareCell {

    @IBOutlet weak var imageView: ImageZoomView!
    @IBOutlet weak var label: UILabel!
    
    func fillWithData(_ data: DataSourceItem) {
        imageView.topAlignedAspectFill = true
        if let imageName = data.payload as? String {
            imageView.image = UIImage(named: imageName)
        }
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attrs = layoutAttributes as? ProfilePhotoScrollerLayoutAttributes {
            imageView.contentMode = attrs.contentMode
            imageView.zoomEnabled = attrs.zoomEnabled
            
            imageView.index = attrs.indexPath.item
            label.text = String(imageView.index)
        }
        
    }
}
