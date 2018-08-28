//
// Created by Victor Zinets on 8/28/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

import UIKit

class PhotoLayoutAttributes : UICollectionViewLayoutAttributes {
    var contentMode: UIViewContentMode = .scaleAspectFill
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let attrs = super.copy(with: zone) as! PhotoLayoutAttributes
        attrs.contentMode = contentMode
        return attrs
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? PhotoLayoutAttributes {
            if obj.contentMode != contentMode {
                return false
            } else {
                return super.isEqual(object)
            }
        } else {
            return false
        }
    }
}
