//
//  RemainCounterView.swift
//  remainCounterProto
//
//  Created by Viktor Zinets on 03.01.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class RemainCounterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    // MARK: outlets etc -
    private var textLabel: UILabel!
    private var progressLayer: CAShapeLayer!
    
    private func commonInit() {
        textLabel = UILabel()
        textLabel.text = "100"
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        textLabel.textColor = .black
        
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 16),
            textLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
        ])
    }

}
