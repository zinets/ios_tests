//
//  ViewController.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var photoCollection: PhotoScroller!
    var photoDatasource = PhotoScrollerDatasource()
    
    @IBOutlet weak var favoritesCollection: FavoritesList!
    var favoritesDatasource  = FavoritesListDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollection.dataSource = photoDatasource
        favoritesCollection.dataSource = favoritesDatasource
        
    }

    
    let urls: [String] = [
        "https://www.white-ibiza.com/wp-content/uploads/wellbeing-opener.jpg",
        "https://ae01.alicdn.com/kf/HTB10Nk9eDnI8KJjy0Ffq6AdoVXar/Ceremokiss-Summer-Sexy-Club-Swimwear-Women-Bikini-Sets-Stripes-Bandage-Swimsuit-Push-Up-Bathing-Suit-Brazilian.jpg",
        "https://www.dhresource.com/0x0s/f2-albu-g5-M01-8E-87-rBVaI1k-RhKAXE7jAAaagwlQR_4251.jpg/velvet-bikini-2017-sexy-micro-bikinis-women.jpg",
        "https://www.dhresource.com/albu_226507030_00-1.0x0/halter-dropshipping.jpg",
        "https://thumbs.dreamstime.com/b/bikini-girl-sitting-seaside-rock-15452009.jpg",
        "https://i.pinimg.com/originals/c4/81/e0/c481e0eca617af42933ff5a8c747dc67.jpg",
        "https://www.glifting.co.uk/wp-content/uploads/2017/03/Glifting-Girls-Ibiza-2017-2-1024x683.jpg",
        "https://c1.staticflickr.com/5/4109/5447991626_2121c39120_b.jpg",
        ]
    
    
    @IBAction func reloadPhotos(_ sender: Any) {
        var newData = [DataSourceItem]()
        for x in 0..<3 {
            let newItem = DataSourceItem(.TestPhotoItem, payload: urls[x])
            newData.append(newItem)
        }
        
        photoDatasource.items = newData        
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        var newData = photoDatasource.items
        let newItem = DataSourceItem(.TestPhotoItem, payload: urls[5])
        // датасорс может найти различия между старым и новым массивом - но кто должен проверять дублирование данных??
        if !newData.contains(newItem) {
            newData.append(newItem)
            
            photoDatasource.items = newData
        }
    }
    
    @IBAction func removePhoto(_ sender: Any) {
        if !photoDatasource.items.isEmpty {
            var items = photoDatasource.items
            items.remove(at: 0)
            
            photoDatasource.items = items
        }
    }
    
    
    
    @IBAction func reloadFavorites(_ sender: Any) {
        
        var newData = [DataSourceItem]()
        let names: [String] = [
            "Natasha",
            "Vasilisa",
            "Agripina"
        ]
        
        
        for x in 0..<3 {
            let newItem = DataSourceItem(.TestFavoriteItem, payload: UserInfo(screenName: names[x], avatarUrl: urls[x]))
            newData.append(newItem)
        }
        
        favoritesDatasource.items = newData
    }
    
    @IBAction func addFavoritka(_ sender: Any) {
        var data = favoritesDatasource.items
        let newUser = DataSourceItem(.TestFavoriteItem, payload: UserInfo(screenName: "Katya", avatarUrl: urls[5]))
        
        if !data.contains(newUser) {
            data.append(newUser)
            favoritesDatasource.items = data
        }
    }
    
    @IBAction func removeFavoritka(_ sender: Any) {
        var data = favoritesDatasource.items
        if !data.isEmpty {
            data.remove(at: 0)
            
            favoritesDatasource.items = data
        }
    }
    
}

