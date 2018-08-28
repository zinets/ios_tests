//
//  PhotoFromInternetCell.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import TNURLImageView

class PhotoFromInternetCell: UICollectionViewCell {

    @IBOutlet weak var imageView: TNImageView!

    var data: PhotoFromInternetModel? {
        didSet {
            if let photoData = data {
                imageView.allowLoadingAnimation = false
                imageView.loadImage(fromUrl: photoData.url)
            }
        }
    }
    var imageContentMode: UIViewContentMode {
        get {
            return imageView.contentMode
        }
        set (newValue) {
            imageView.contentMode = newValue
        }
    }

    var image: UIImage? {
        return imageView.image
    }

    // MARK: overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.contentModeAnimationDuration = 0.25
    }

    override func prepareForReuse() {
        imageView.image = nil
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if let attrs = layoutAttributes as? PhotoLayoutAttributes {
            imageContentMode = attrs.contentMode
        }
    }
}
