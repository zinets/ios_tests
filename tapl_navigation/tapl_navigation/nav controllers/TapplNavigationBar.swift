//
//  TapplNavigationBar.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplNavigationBar: UINavigationBar {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .red
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
        commonInit()
    }
    
    private func commonInit() {
        self.isTranslucent = false
        shadowImage = UIImage()
    }
    
    override func pushItem(_ item: UINavigationItem, animated: Bool) {

    }
  
    
}
