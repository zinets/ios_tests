//
//  ZoomTestController.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/13/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class ZoomTestController: UIViewController {

    
    @IBOutlet weak var photoScroller: ProfilePhotoScrollerView!
    @IBOutlet weak var zoomView: ImageZoomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var photos = [DataSourceItem]()
        
        var photoItem = DataSourceItem("ProfileTopPhotoItem")
        photoItem.payload = "girl1.jpg"
        photos.append(photoItem)
        
                photoItem = DataSourceItem("ProfileTopPhotoItem")
                photoItem.payload = "girl2.jpg"
                photos.append(photoItem)
        
                photoItem = DataSourceItem("ProfileTopPhotoItem")
                photoItem.payload = "girl3.jpg"
                photos.append(photoItem)
        
        photoScroller.items = photos
        
//        zoomView.image = UIImage(named: "girl1.jpg")
    }

}
