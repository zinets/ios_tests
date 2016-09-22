//
//  GameModel.swift
//  testT1
//
//  Created by Zinets Victor on 9/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

import UIKit

class GameModel: NSObject {
    private var matrix: Matrix
    
    override init() {
        matrix = [
            [.Empty, .Empty, .Empty, .Empty],
            [.Empty, .Square, .Square, .Empty],
            [.Empty, .Square, .Square, .Empty],
            [.Empty, .Empty, .Empty, .Empty]
        ]
    }
    
    func numberofRows() -> Int {
        return 4
    }
    func numberOfCols() -> Int {
        return 4
    }
    
}
