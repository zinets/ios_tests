//
//  ViewController.swift
//  testProgresView
//
//  Created by Victor Zinets on 12.09.2022.
//

import UIKit

public typealias StorageKey = String
extension StorageKey {
    static let database = "database"
    
    var user: String { self + ".user" }
    var prop2: String { self + ".prop2"}
    var prop3: String { self + ".prop3"}
    var boolProp: String { self + ".boolProp"}
}

class ViewController: UIViewController {
    
    var storage: [StorageKey: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    
    }

    // MARK: -
    private func dictForValue(_ value: Any, path: String) -> [String: Any]? {
        var parts = path.components(separatedBy: ".")
        let keyName = parts.removeLast()
        let dict = [keyName: value]
        
        if !parts.isEmpty {
            return dictForValue(dict, path: parts.joined(separator: "."))
        }
        
        return dict
    }
    
    private func append(dict: [String: Any], to storage: [String: Any]) -> [String: Any] {
        for key in dict.keys {
            if let leaf = storage[key] as? [String: Any],
               let d = dict[key] as? [String : Any] {
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
    
    func get(key: String) -> Any? {
        
        var parts = key.components(separatedBy: ".")
        let keyName = parts.removeLast()
        
        func getTopLeaf(_ r: String, storage: [String: Any]) -> [String: Any]? {
            var parts = r.components(separatedBy: ".")
            let key = parts.removeLast()
            if !parts.isEmpty {
                let d = getTopLeaf(parts.joined(separator: "."), storage: storage) ?? [:]
                
                if key == keyName {
                    return d
                } else {
                    return d[key] as? [String: Any]
                }
            } else {
                return storage[key] as? [String: Any]
            }
        }
        
        if let d = getTopLeaf(parts.joined(separator: "."), storage: storage) {
            return d[keyName]
        }
        
        return nil
    }
    
    
    
    @IBAction func test2(_ sender: Any) {
        
        if let dictToSave = dictForValue(123, path: .database.user.prop2) {
            storage = append(dict: dictToSave, to: storage)
        }
        if let dictToSave = dictForValue(true, path: .database.user.prop3) {
            storage = append(dict: dictToSave, to: storage)
        }
        print(storage)
    }
    
    @IBAction func test2read(_ sender: Any) {
        let r = get(key: .database.user.prop2)
        print(r)
    }
    
    
    
    
    
    
    
    
    
    @IBAction func testStore(_ sender: Any) {
        FileStorage.global[.database.user.prop2] = 117
        FileStorage.global[.database.user.prop3] = [1, 13, 55, 1024]
        
        FileStorage.global[.database.user.boolProp] = true
    }
    
    @IBAction func testGet(_ sender: Any) {
        print(FileStorage.global.bool(for: .database.user.boolProp))
        
        print(FileStorage.global[.database.user.prop2])
        print(FileStorage.global[.database.user.prop3])
    }
    
}
