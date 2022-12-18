//
//  FTStatProgressType.swift
//  protoStats
//
//  Created by Victor Zinets on 18.12.2022.
//

import UIKit

enum FTStatProgressType: Int {
    case like, match, watch // FIXME: кто такой watch?
    
    var iconImage: UIImage? {
        switch self {
        case .like: return UIImage(named: "statTypeLike")
        case .match: return UIImage(named: "statTypeMatch")
        case .watch: return UIImage(named: "statTypeWatch")
        }
    }
    
    var gradientColors: [UIColor] {
        switch self {
        case .like: return [.red, .orange]
        case .match: return [.yellow, .gray]
        case .watch: return [.magenta, .blue]
        }
    }
    
    func counterText(usePlural: Bool) -> String {
        switch self {
        case .like: return usePlural ? "likes" : "like" // FIXME: localization
        case .match: return usePlural ? "matches" : "match"
        case .watch: return usePlural ? "watches" : "watch"
        }
    }
}





