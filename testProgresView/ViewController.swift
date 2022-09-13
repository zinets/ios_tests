//
//  ViewController.swift
//  testProgresView
//
//  Created by Victor Zinets on 12.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: -
    
    @IBAction func testStore(_ sender: Any) {
        let key = StorageKeys.database.server.sessionTimeout
        FileStorage.global[key] = 117
        
        FileStorage.global[StorageKeys.database.user.oneLimeLogic.oneTimeCompleted] = false
        FileStorage.global[StorageKeys.database.server.sessionCount] = [1, 13, 55, 1024]
    }
    
    @IBAction func testGet(_ sender: Any) {
        let key = StorageKeys.database.server.sessionTimeout
        print(FileStorage.global.integer(for: key))
        
        print(FileStorage.global.bool(for: StorageKeys.database.user.oneLimeLogic.oneTimeCompleted))
        print(FileStorage.global[StorageKeys.database.server.sessionCount])
    }
    
}
