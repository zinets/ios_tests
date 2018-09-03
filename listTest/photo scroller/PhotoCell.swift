//
//  PhotoCell.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import TNURLImageView

class PhotoCell: UICollectionViewCell {

    
    @IBOutlet weak var photoView: TNImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillData(_ data: DataSourceItem) {
        photoView.loadImage(fromUrl: data.payload as? String)
    }
}

