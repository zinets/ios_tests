//
//  ProfilePhotoCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import TNURLImageView
import CollectionControls

class ProfilePhotoCell: UICollectionViewCell, DataAwareCell {

    @IBOutlet weak var imageView: TNImageView!

    func fillWithData(_ data: DataSourceItem) {
        if let imageName = data.payload as? String {
            imageView.image = UIImage(named: imageName)
        }
    }

}
