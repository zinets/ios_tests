//
//  ViewController.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController/*, IPageControlDatasource*/ {
    
    var instaCtrl2: IPageControl = {
        let ctrl = IPageControl(frame: CGRect(x: 50, y: 50, width: 200, height: 10))
        ctrl.backgroundColor = UIColor.brown
        ctrl.numberOfPages = 10
        return ctrl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let instaCtrl = InstagramPageControl(frame: CGRect(x: 50, y: 100, width: 50, height: 10))
//        instaCtrl.backgroundColor = UIColor.brown
//        view.addSubview(instaCtrl)        
//        instaCtrl.dotSize = 20
//
//        instaCtrl.dataSource = self
//        instaCtrl.displayCount = 6
//        instaCtrl.numberOfPages = 10
//        instaCtrl.currentPage = 0
        
        
        
    }
    
    @IBAction func decInstaCounter(_ sender: Any) {
        let index = instaCtrl2.pageIndex - 1
        instaCtrl2.setCurrentPage(at: index)
    }
    
    @IBAction func addInstaCounter(_ sender: Any) {
        let index = instaCtrl2.pageIndex + 1
        instaCtrl2.setCurrentPage(at: index)
    }
    
    @IBAction func showProfile(_ sender: Any) {
        if let ctrl = UIStoryboard.init(name: "Profile", bundle: nil).instantiateInitialViewController() {
            self.show(ctrl, sender: nil)
        }
        
    }
    
    @IBOutlet weak var testView: UIView!
    
    @IBAction func testAnimation(_ sender: UIButton) {
        
    }
    
    
    // MARK: profile photo test -
    
    @IBOutlet weak var profilePhotoScroller: ProfilePhotoScrollerView!
    @IBOutlet weak var smallScrollerView: SmallPhotosScroller!
    
    @IBAction func reloadPhotos(_ sender: Any) {
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
        
        profilePhotoScroller.items = photos
        
        var smallPhotos = [DataSourceItem]()
        for item in photos {
            let smallItem = DataSourceItem("ProfilePhotosListItem")
            smallItem.payload = item.payload
            
            smallPhotos.append(smallItem)
        }
        
        smallScrollerView.items = smallPhotos
    }
    
    
}

