//
//  ObjClassModel.swift
//  testObserving
//
//  Created by Victor Zinets on 11/1/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ObjClassModel {
    var internalData: ObjClass!
    
    init(with objClass: ObjClass) {
        self.internalData = objClass
    }
    
    func numberOfMessages() -> Int {
        return internalData.msgs.count
    }
    
    func message(forIndex: Int) -> String {
        return internalData.msgs.object(at: forIndex) as! String
    }
    
    func caption() -> String {
        return internalData.caption
    }
    
    func addRandomElement() {
        internalData.addRandomElement()
    }
}
