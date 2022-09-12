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
        print(StorageDomain.database.user.sessionCount)
    }
    
}

// FileStorage.currentUserStorage?[.database.user.sessionCount] = 5


struct StorageDomain {
    static var database = DB()
}

struct DB: CustomStringConvertible {
    var description: String { "database." }
    
    lazy var user = { UserData(reverse: description) }()
}

struct UserData: CustomStringConvertible {
    private var reverse: String
    init(reverse: String) {
        self.reverse = reverse
    }
    var description: String { reverse + "user." }
    
    //
    lazy var firstLogin = { LastField(value: "firstLogin", reverse: description) }()
    lazy var sessionCount = { LastField(value: "sessionCount", reverse: description) }()
}

struct LastField: CustomStringConvertible {
    private var intValue: String
    private var reverse: String
    
    init(value: String, reverse: String) {
        self.reverse = reverse
        self.intValue = value
    }
    
    var description: String {
        return reverse + intValue
    }
}
