//
//  ProfilePhotoScrollerView.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

/// конкретный скроллер конкретных вещей - фотографий юзера; с зумом
class ProfilePhotoScrollerView: CollectionBasedScrollerView {
    
    override open func commonInit() {
        super.commonInit()
        
        self.paginating = true
        self.oneElementPaginating = true
    }
    
    override func layoutForCollection() -> UICollectionViewLayout {
        let layout = ProfilePhotoScrollerLayout()
        layout.contentMode = self.contentMode
        return layout
    }
    
    override func datasourceForCollection() -> CollectionSectionDatasource {
        return ProfilePhotoScrollerDatasource()
    }

    // MARK: animated bounds changing -
    
    override var contentMode: UIViewContentMode {
        didSet {
            if let layout = collectionView.collectionViewLayout as? ProfilePhotoScrollerLayout {
                layout.contentMode = contentMode
            }
        }
    }
    
    var zoomEnabled = false {
        didSet {
            if let layout = collectionView.collectionViewLayout as? ProfilePhotoScrollerLayout {
                layout.zoomEnabled = zoomEnabled
            }
        }
    }
    
    
    
    
    
    func curImage() -> UIImage? {
        if let cell = self.collectionView.visibleCells.first as? ProfilePhotoCell {
            return cell.imageView.image
        }
        
        return nil
    }
    
    func cloneImageView() -> ImageZoomView? {
        if let cell = self.collectionView.visibleCells.first as? ProfilePhotoCell {
            let clone = ImageZoomView(frame: cell.imageView.frame)
            
            
            clone.minimumZoomScale = cell.imageView.minimumZoomScale
            clone.maximumZoomScale = cell.imageView.maximumZoomScale
            clone.zoomScale = cell.imageView.zoomScale
            
            
            clone.contentSize = cell.imageView.contentSize
            clone.contentOffset = cell.imageView.contentOffset
            clone.contentInset = cell.imageView.contentInset
            
            clone.contentMode = cell.imageView.contentMode
            clone.image = cell.imageView.image
            
            
            
            
            
            return clone
        }
        
        return nil
    }
    
    
}
