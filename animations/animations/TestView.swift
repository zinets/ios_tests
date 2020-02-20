//
//  TestView.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class TestView: UIView, XibView {
    @IBOutlet weak var testLabel: UILabel!
    
    // MARK: common init routine -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInternalView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInternalView()
    }
}
