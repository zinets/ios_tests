//
//  FullScreenCell.swift
//
//  Created by Victor Zinets on 8/7/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit
import DiffAble
import TNURLImageView

class FullScreenPhotoCell: UICollectionViewCell, AnyDiffAbleControl {
    
    @IBOutlet weak var imageView: ImageZoomView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // эта проперть будет использоваться аниматором для настройки промежуточного вью - если мы сделали зум, то возращаться будем из этого зума, чтоб красиво
    var currentZoomScale: CGFloat? {
        guard imageView.zoomEnabled else {
            return nil
        }
        return imageView.zoomScale
    }    
    
    var currentImage: UIImage? {
        return self.imageView.image
    }
    private var photoId: UInt?
        
    func configure(_ item: AnyDiffAble) {
        if let item = item.payload as? FullScreenItem {
            activityIndicator.startAnimating()

            imageView.zoomEnabled = item.videoUrl == nil
            
            let source = TNRemoteResource.with(item.photoUrl)
            self.photoId = TNPhotoManager.shared().loadResource(from: source, onComplete: { [weak self] (image, imageId) in
                if self?.photoId == imageId {
                    self?.imageView.image = image
                    self?.photoId = nil
                }
                
                self?.activityIndicator.stopAnimating()
            })
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}


