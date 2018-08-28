//
// Created by Victor Zinets on 8/28/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

import Foundation

class PhotoFromInternetModel : Equatable, Hashable {
    var url: String?
    
    public static func == (lhs: PhotoFromInternetModel, rhs: PhotoFromInternetModel) -> Bool {
        return lhs.url == rhs.url
    }
    
    var hashValue: Int {
        if let u = url {
            return u.hashValue
        } else {
            return 0
        }
    }
}
