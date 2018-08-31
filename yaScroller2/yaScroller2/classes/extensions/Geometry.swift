//
//  Geometry.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

extension CGRect {
    func center() -> CGPoint {
        return CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    }
}
