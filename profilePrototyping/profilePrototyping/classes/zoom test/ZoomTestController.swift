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
    @IBOutlet weak var zoomViewHeightConstraint: NSLayoutConstraint!
    
    
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

    @IBAction func fsZoomView(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        UIView.animate(withDuration: 0.7) {
            if sender.isSelected {
                self.zoomViewHeightConstraint.constant = 16
            } else {
                self.zoomViewHeightConstraint.constant = 230
            }
            
            self.view .layoutIfNeeded()
        }
    }
}
