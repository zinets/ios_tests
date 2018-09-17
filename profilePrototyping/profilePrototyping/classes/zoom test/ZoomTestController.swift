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

        self.photoScroller.contentMode = .scaleAspectFill
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var photos = [DataSourceItem]()
        
        var photoItem = DataSourceItem("ProfileTopPhotoItem")
        photoItem.payload = "girl2.jpg"
        photos.append(photoItem)
        
        photoItem = DataSourceItem("ProfileTopPhotoItem")
        photoItem.payload = "girl1.jpg"
        photos.append(photoItem)
        
        photoItem = DataSourceItem("ProfileTopPhotoItem")
        photoItem.payload = "girl3.jpg"
        photos.append(photoItem)
        
        photoItem = DataSourceItem("ProfileTopPhotoItem")
        photoItem.payload = "girl5.jpg"
        photos.append(photoItem)
        
        photoScroller.items = photos
        
//        zoomView.image = UIImage(named: "girl1.jpg")
    }

    @IBAction func fsZoomView(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
//        let image = photoScroller.curImage()
//        let fakeImageView = ImageZoomView(frame: photoScroller.frame)
//        fakeImageView.image = image
//        fakeImageView.topAlignedAspectFill = true
//        fakeImageView.contentMode = photoScroller.contentMode
        
        
        if let fakeImageView = photoScroller.cloneImageView() {            
            let frame = self.view.convert(fakeImageView.frame, from: photoScroller)
            fakeImageView.frame = frame
            photoScroller.superview?.addSubview(fakeImageView)
            
            fakeImageView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: fakeImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: photoScroller, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: fakeImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: photoScroller, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            let widthConstraint = NSLayoutConstraint(item: fakeImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: photoScroller, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
            let heightConstraint = NSLayoutConstraint(item: fakeImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: photoScroller, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
            
            self.view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
            
            
            
            photoScroller.isHidden = true
            
            
            UIView.animate(withDuration: 0.7, animations: {
                let newHeight: CGFloat = sender.isSelected ? 600 : 375
                self.zoomViewHeightConstraint.constant = newHeight
                self.view.layoutIfNeeded()
                self.photoScroller.contentMode = sender.isSelected ? .scaleAspectFit : .scaleAspectFill
                
                fakeImageView.contentMode = self.photoScroller.contentMode
                
            }) { (finished) in
                
                self.photoScroller.isHidden = false
                fakeImageView.removeFromSuperview()
            }
        }
       
        self.photoScroller.zoomEnabled = sender.isSelected
    }
}
