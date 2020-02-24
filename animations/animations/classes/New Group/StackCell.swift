//
//  StackCell.swift
//  animations
//
//  Created by Viktor Zinets on 21.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

// just as example
protocol LikeBookCellDelegate: class {
    func didSomeAction()
}

class StackCell: StackCardsBaseCellView, DiffAbleCell {

    weak var actionDelegate: LikeBookCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(hue: CGFloat.random(in: 0..<1), saturation: 0.7, brightness: 1, alpha: 1)
    }
    
    // MARK: outlets -
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lorderLabel: UILabel!
    
    @IBAction func buttonAction(_ sender: Any) {
        if let delegate = self.actionDelegate {
            delegate.didSomeAction()
        }
    }
    
    func configure(_ item: DatasourceItem) {
        label.text = item.data
    }
}



