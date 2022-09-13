//
//  FileStorageProtocol.swift
//  PhoenixSDK
//
//  Created by Vladyslav Popovych on 22.07.2021.
//

import Foundation

public typealias StorageKey = String

public protocol FileStorageProtocol: AnyObject {
    subscript(key: StorageKey) -> Any? { get set }
}

// Бесплатные методы, которые получит любой класс сторежда, если законформит протоколу
public extension FileStorageProtocol {
    
    func url(for key: StorageKey) -> URL? {
        self[key] as? URL
    }

    func array(for key: StorageKey) -> [Any] {
        (self[key] as? [Any]) ?? []
    }

    func dictionary(for key: StorageKey) -> [String : Any] {
        (self[key] as? [String : Any]) ?? [:]
    }

    func string(for key: StorageKey) -> String {
        (self[key] as? String) ?? ""
    }

    func stringArray(for key: StorageKey) -> [String] {
        (self[key] as? [String]) ?? []
    }

    func data(for key: StorageKey) -> Data? {
        self[key] as? Data
    }

    func bool(for key: StorageKey) -> Bool {
        guard let object = self[key] else {
            return false
        }
        if let nsnumber = object as? NSNumber {
            return nsnumber.boolValue
        } else if let string = object as? String {
            // Это конечно хорошо, но тому кто положит такую подливу и начнет требовать бул, надо дать по рукам
            // Сделал ради совместимости с эпловским парсингом
            if string.uppercased() == "YES" || string == "true" {
                return true
            } else if string.uppercased() == "NO" || string == "false" {
                return false
            }
            return (Double(string) ?? 0.0) != 0.0
        }
        return (object as? Bool) ?? false
    }

    func integer(for key: StorageKey) -> Int {
        (self[key] as? Int) ?? 0
    }

    func float(for key: StorageKey) -> Float {
        (self[key] as? Float) ?? .zero
    }

    func double(for key: StorageKey) -> Double {
        (self[key] as? Double) ?? .zero
    }
}
