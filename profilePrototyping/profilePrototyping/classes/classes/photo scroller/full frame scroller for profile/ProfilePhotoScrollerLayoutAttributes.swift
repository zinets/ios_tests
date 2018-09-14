//
//  ProfilePhotoScrollerLayoutAttributes.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

/// раскладка использует кастомный класс атрибутов для передачи в ячейку типа отображения фото - fit или fill, и параметр zoomEnabled
class ProfilePhotoScrollerLayoutAttributes : UICollectionViewLayoutAttributes {
    var contentMode: UIViewContentMode = .scaleAspectFill
    var zoomEnabled: Bool = false
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let attrs = super.copy(with: zone) as! ProfilePhotoScrollerLayoutAttributes
        attrs.contentMode = contentMode
        attrs.zoomEnabled = zoomEnabled
        return attrs
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? ProfilePhotoScrollerLayoutAttributes {
            if obj.contentMode != contentMode ||
               obj.zoomEnabled != zoomEnabled {
                return false
            } else {
                return super.isEqual(object)
            }
        } else {
            return false
        }
    }
}
