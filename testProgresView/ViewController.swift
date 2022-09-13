//
//  ViewController.swift
//  testProgresView
//
//  Created by Victor Zinets on 12.09.2022.
//

import UIKit


extension StorageKey {
    static let database = "database"
    
    var user: String { self + ".user" }
    var prop2: String { self + ".prop2"}
    var prop3: String { self + ".prop3"}
    var boolProp: String { self + ".boolProp"}
}

class ViewController: UIViewController {
    
    
    @IBAction func testStore(_ sender: Any) {
        FileStorage.global[.database.user.prop2] = 117
        FileStorage.global[.database.user.prop3] = [1, 13, 55, 1024]
        
        FileStorage.global[.database.user.boolProp] = true
        
//      проблема в том, что можно написать такую чушь
//        FileStorage.global[.database.user.prop3.prop2.prop3]
//      и никак это не проверить и предотвратить (ну на первый взгляд)
    }
    
    @IBAction func testGet(_ sender: Any) {
        print(FileStorage.global.bool(for: .database.user.boolProp))
        
        print(FileStorage.global.array(for: .database.user.prop3))
        print(FileStorage.global[.database.user.prop2] as? Int)
    }
    
}
