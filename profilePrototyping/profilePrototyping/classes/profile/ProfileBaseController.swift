//
//  ProfileBaseController.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileBaseController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let profileDatasource = ProfileDatasource(ProfileCellsFactory())
    
    @IBOutlet weak var shadeView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shadeView.alpha = 0

        var items = [DataSourceItem]()
        
        let userInfo: UserInfo = UserInfo()
        userInfo.screenName = "QVovan Padavan"
        userInfo.age = 29
        userInfo.location = "Zaporizhzhya, Ukraine"
        userInfo.aboutDescription = "Чоткий пацан, якого люблять девки шо дньом, шо ноччю"
        userInfo.about = ["Looking for" : "Man",
                          "Height": "170 cm",
                          "Body": "Medium",
                          "Orientation": "Straight",
                          "Marital status": "Free",
                          "Smoke": "No",
                          "Drink": "Always",
                          "Children": "Never"]
//        userInfo.photos = ["userPhoto1.jpg"]
        
        var item = DataSourceItem("ProfileOwnPhotoItem")
        item.payload = userInfo
//        items.append(item)
        
        // buttons
        item = DataSourceItem("ProfileButtonsItem")
        items.append(item)
        
        item = DataSourceItem("ProfileAboutInfoItem")
        item.payload = userInfo
        items.append(item)
        
        item = DataSourceItem("ProfileAboutSubtitleItem")
        item.payload = "About"
        items.append(item)
        
        item = DataSourceItem("ProfileAboutDescriptionItem")
        item.payload = userInfo
        items.append(item)
        
        item = DataSourceItem("ProfileAboutSubtitleItem")
        item.payload = "Personality"
        items.append(item)
        
        for (a, b) in userInfo.about {
            item = DataSourceItem("ProfileAboutItem")            
            item.payload = UserInfoAboutItem.init(a, value: b)
            items.append(item)
        }
        
        
        
        profileDatasource.items = items
        profileDatasource.tableView = self.tableView

    }
    
    // MARK: table delegate -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / 420
        
        if offset > 0 {
            shadeView.alpha = offset
            photoView.transform = CGAffineTransform.identity
        } else {
            shadeView.alpha = 0
            let downOffset = min(1, (-scrollView.contentOffset.y + scrollView.contentInset.top) / 100)
            let magicConst: CGFloat = 0.5 // на сториборде фрейм картинки = 1.5 ширины контроллера
            let scale:CGFloat = 1 / (magicConst * downOffset + 1)
            photoView.transform = CGAffineTransform(scaleX: scale, y: scale)
            scrollView.alpha = downOffset < 1 ? 1 : 0
        }
    }
}
