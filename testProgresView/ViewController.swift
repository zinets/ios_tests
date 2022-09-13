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

    var dict2store: [AnyHashable: Any] = [:]
    
    @IBAction func onTest(_ sender: UIButton) {

        var key = StorageDomain.database.user.firstLogin
        if let dictToSave = storeValue(45, reversible: key) {
            print(dictToSave)
            dict2store = append(dict: dictToSave, to: dict2store)
        }
        
        key = StorageDomain.database.user.lastLogin
        if let dictToSave = storeValue("yesterday", reversible: key) {
            print(dictToSave)
            dict2store = append(dict: dictToSave, to: dict2store)
        }
        
        key = StorageDomain.database.server.sessionTimeout
        if let dictToSave = storeValue([1, 3, 7, 11, 13], reversible: key) {
            print(dictToSave)
            dict2store = append(dict: dictToSave, to: dict2store)
        }
        
        key = StorageDomain.oneTimeMigration.oneTimeCompleted
        if let dictToSave = storeValue(true, reversible: key) {
            print(dictToSave)
            dict2store = append(dict: dictToSave, to: dict2store)
        }
    }
    
    private func storeValue(_ value: Any, reversible: Reversible) -> [AnyHashable: Any]? {
        let dict = [reversible.keyName: value]
        
        if let l = reversible.reverse {
            return storeValue(dict, reversible: l)
        }
        
        return dict
    }
    
    private func append(dict: [AnyHashable: Any], to storage: [AnyHashable: Any]) -> [AnyHashable: Any] {
        
        for key in dict.keys {
            
            if let leaf = storage[key] as? [AnyHashable: Any],
               let d = dict[key] as? [AnyHashable : Any] {
                let a = append(dict: d, to: leaf)
                
                var newStorage = storage
                newStorage[key] = a
                return newStorage
            } else {
                var newStorage = storage
                newStorage[key] = dict[key]
                return newStorage
            }
        }
        
        return [:]
    }
    
}
