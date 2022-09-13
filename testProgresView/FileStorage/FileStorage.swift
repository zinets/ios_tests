//
//  FileStorage.swift
//  FileStorage
//
//  Created by Alexander on 20.03.2020.
//  Copyright © 2020 TN. All rights reserved.
//

import Foundation

public final class FileStorage: FileStorageProtocol {

    public static let global = FileStorage(withStorageName: "__GlobalStorage")
    public static private (set) var currentUserStorage: FileStorage?
    
    private var storageName: String!
    private var storage: [AnyHashable: Any] = [:]

    // MARK: - Initializer

    @objc public required init(withStorageName name: String) {
        storageName = name

        if let path = plistPath() {
            if let data = try? Data(contentsOf: path) {
                if let read = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? NSDictionary {
                    storage = read as Dictionary
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func setCurrentUserId(_ userId: String?) {
        guard let id = userId else {
            currentUserStorage = nil
            return
        }
        currentUserStorage = FileStorage(withStorageName: id)
    }
    
    // MARK: - Subscript

    public subscript(key: StorageKey) -> Any? {
        get {
            let keyName = key.keyName
            func getTopLeaf(_ r: Reversible, storage: [AnyHashable: Any]) -> [AnyHashable: Any]? {
                let key = r.keyName
                if let top = r.reverse {
                    let d = getTopLeaf(top, storage: storage) ?? [:]
                    
                    if key == keyName {
                        return d
                    } else {
                        return d[key] as? [AnyHashable: Any]
                    }
                } else {
                    return storage[key] as? [AnyHashable: Any]
                }
            }
            
            if let d = getTopLeaf(key, storage: storage) {
                return d[keyName]
            }
            
            return nil
        }
        set(newValue) {
            // TODO: если приходит nil в newValue - хорошо бы стирать значение (?)
            if let dictToSave = dictForValue(newValue, reversible: key) {
                storage = append(dict: dictToSave, to: storage)
            }
            save()
        }
    }

    // MARK: - Private methods
    private func dictForValue(_ value: Any, reversible: Reversible) -> [AnyHashable: Any]? {
        let dict = [reversible.keyName: value]
        
        if let l = reversible.reverse {
            return dictForValue(dict, reversible: l)
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
    
    private func save() {
        if let path = plistPath() {
            do {
                try (storage as NSDictionary).write(to: path)
            } catch {
                debugPrint("[FileStorage][ERROR] failed to write storage! \(error)")
            }
        }
    }

    private func plistPath() -> URL? {
        if let last = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            if let path = URL(string: "\(last)\(storageName!).plist") {
                return path
            } else {
                debugPrint("[FileStorage][ERROR] failed URL path")
            }
        } else {
            debugPrint("[FileStorage][ERROR] failed access to documentDirectory")
        }
        return nil
    }
}
