//
//  ProfileBaseController.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfileBaseController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let profileDatasource = ProfileDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var items = [DataSourceItem]()
        
        
        // buttons
        var item = DataSourceItem(.ProfileAboutButtonsItem)
        items.append(item)
        
        item = DataSourceItem(.ProfileAboutInfoItem)
        items.append(item)
        
        item = DataSourceItem(.ProfileAboutSubtitleItem)
        item.payload = "About"
        items.append(item)
        
        item = DataSourceItem(.ProfileAboutDescriptionItem)
        items.append(item)
        
        item = DataSourceItem(.ProfileAboutSubtitleItem)
        item.payload = "Personality"
        items.append(item)
        
        item = DataSourceItem(.ProfileAboutItem)
        items.append(item)
        item = DataSourceItem(.ProfileAboutItem)
        items.append(item)
        item = DataSourceItem(.ProfileAboutItem)
        items.append(item)
        
        
        profileDatasource.items = items
        profileDatasource.tableView = self.tableView

    }
}
