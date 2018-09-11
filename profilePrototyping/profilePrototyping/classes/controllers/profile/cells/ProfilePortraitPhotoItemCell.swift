//
//  ProfilePortraitPhotoItemCell.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/11/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class ProfilePortraitPhotoItemCell: ProfileItemCell {

    @IBOutlet weak var photosCountLabel: UILabel!
    @IBOutlet weak var portraitScrollerView: SmallPhotosScroller!
    
    override func fillWithData(_ data: DataSourceItem) {
        if let photos =  data.payload as? [String] {
            photosCountLabel.text = String(photos.count)
        }
    }
   
}
