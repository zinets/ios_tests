//
//  FileStorage.swift
//  FileStorage
//
//  Created by Alexander on 20.03.2020.
//  Copyright © 2020 TN. All rights reserved.
//

import Foundation

public final class FileStorage: FileStorageProtocol {
//    @objc(globalStorage)
    public static let global = FileStorage(withStorageName: "__GlobalStorage")
    public static private (set) var currentUserStorage: FileStorage?
    
    private var storageName: String!
    private var storage: NSMutableDictionary?

    // MARK: - Initializer

    @objc public required init(withStorageName name: String) {
        storageName = name

        if let path = plistPath() {
            if let data = try? Data(contentsOf: path) {
                storage = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? NSMutableDictionary
            }

            if storage == nil {
                storage = [:]
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

    public subscript(key: String) -> Any? {
        get {
            return storage?[key]
        }
        set(newValue) {
//            guard newValue is NSNumber, NSDate, NSString, NSData, NSArray, NSDictionary else { fatalError() }
            // а не всякие Bool или тем более значения энумов
            storage?[key] = newValue
            save()
        }
    }

    // MARK: - Private methods

    private func save() {
        if let path = plistPath() {
            do {
                try storage?.write(to: path)
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
