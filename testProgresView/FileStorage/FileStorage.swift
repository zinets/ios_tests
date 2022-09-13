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
    private var storage: [String: Any] = [:]

    // MARK: - Initializer

    @objc public required init(withStorageName name: String) {
        storageName = name

        if let path = plistPath() {
            if let data = try? Data(contentsOf: path) {
                if let read = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? NSDictionary {
                    storage = read as? Dictionary<String, Any> ?? [:]
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
        set(newValue) {
            // TODO: если приходит nil в newValue - хорошо бы стирать значение (?)
            if let dictToSave = dictForValue(newValue, path: key) {
                storage = append(dict: dictToSave, to: storage)
            }
            save()
        }
    }

    // MARK: - Private methods
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
