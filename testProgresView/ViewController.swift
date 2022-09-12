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

   
    
    @IBAction func onTest(_ sender: UIButton) {
        print(StorageDomain.database.user.firstLogin)
        print(StorageDomain.database.server.sessionCount)
        StorageDomain.oneTimeMigration.migration.feature1
    }
    
}

// FileStorage.currentUserStorage?[.database.user.sessionCount] = 5


class StorageDomain {
    static var database = Database()
    static var oneTimeMigration = OneTimeLogic()
}





class Domain: CustomStringConvertible {
    var description: String { "database." }
}

final class Database: Domain {
    lazy var user = { UserData(reverse: self) }()
    lazy var server = { ServerData(reverse: self) }()
}

final class OneTimeLogic: Domain {
    lazy var feature1 = { data("feature1") }()
}
