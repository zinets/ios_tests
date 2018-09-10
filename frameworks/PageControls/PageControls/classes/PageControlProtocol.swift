//
//  PageControlProtocol.swift
//  PageControls
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import Foundation

@objc public protocol PageControlProtocol {
    var numberOfPages: Int { get set }
    var pageIndex: Int { get set }
}
