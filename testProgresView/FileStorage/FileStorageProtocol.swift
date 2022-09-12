//
//  FileStorageProtocol.swift
//  PhoenixSDK
//
//  Created by Vladyslav Popovych on 22.07.2021.
//

import Foundation

public protocol FileStorageProtocol: AnyObject {
    subscript(key: String) -> Any? { get set }
}

// Бесплатные методы, которые получит любой класс сторежда, если законформит протоколу
public extension FileStorageProtocol {
    
    func url(for key: String) -> URL? {
        self[key] as? URL
    }

    func array(for key: String) -> [Any] {
        (self[key] as? [Any]) ?? []
    }

    func dictionary(for key: String) -> [String : Any] {
        (self[key] as? [String : Any]) ?? [:]
    }

    func string(for key: String) -> String {
        (self[key] as? String) ?? ""
    }

    func stringArray(for key: String) -> [String] {
        (self[key] as? [String]) ?? []
    }

    func data(for key: String) -> Data? {
        self[key] as? Data
    }

    func bool(for key: String) -> Bool {
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

    func integer(for key: String) -> Int {
        (self[key] as? Int) ?? 0
    }

    func float(for key: String) -> Float {
        (self[key] as? Float) ?? .zero
    }

    func double(for key: String) -> Double {
        (self[key] as? Double) ?? .zero
    }
}
