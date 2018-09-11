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

    @IBOutlet weak var photoScrollerHeight: NSLayoutConstraint!
    @IBOutlet weak var photosCountLabel: UILabel!
    @IBOutlet weak var portraitScrollerView: SmallPhotosScroller!
    
    override func fillWithData(_ data: DataSourceItem) {
        if let userPhotos =  data.payload as? [String] {
            photosCountLabel.text = String(userPhotos.count)
            self.photoScrollerHeight.constant = userPhotos.count > 2 ? 194 : 270
            
            var photos = [DataSourceItem]()
            for imageName in userPhotos {
                let item = DataSourceItem("PortraitProfilePhotoItem")
                item.payload = imageName
                
                photos.append(item)
            }
            
            portraitScrollerView.items = photos
        }
    }   
}
