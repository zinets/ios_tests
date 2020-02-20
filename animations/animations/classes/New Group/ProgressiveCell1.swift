//
//  ProgressiveCell1.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class ProgressiveCell1: UICollectionViewCell {
    
    @IBOutlet weak var progressLabel: UILabel!
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let pr = UIPanGestureRecognizer(target: self, action: #selector(swipeCard(sender:)))
        return pr
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(hue: CGFloat.random(in: 0..<1), saturation: 1, brightness: 1, alpha: 1)
        self.addGestureRecognizer(self.panRecognizer)
    }
    
    @objc func swipeCard(sender: UIPanGestureRecognizer) {
        sender.swipeView()
    }

    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        self.panRecognizer.isEnabled = layoutAttributes.indexPath.item == 0
        
        guard let attrs = layoutAttributes as? CollectionViewProgressLayoutAttributes else { return }
        progressLabel.text = "progress: \(attrs.progress)"
    }
}

struct DatasourceItem: Item {
    var cellReuseId: String = "StackCell"
    var data: String
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.cellReuseId == rhs.cellReuseId
            && lhs.data == rhs.data
    }
}

protocol DiffAbleCell {
    func configure(_ item: DatasourceItem)
}

class StackCell: UICollectionViewCell, DiffAbleCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(hue: CGFloat.random(in: 0..<1), saturation: 1, brightness: 1, alpha: 1)
        self.addGestureRecognizer(self.panRecognizer)
    }
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let pr = UIPanGestureRecognizer(target: self, action: #selector(swipeCard(sender:)))
        return pr
    }()
    @objc func swipeCard(sender: UIPanGestureRecognizer) {
        sender.swipeView()
    }
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.panRecognizer.isEnabled = layoutAttributes.indexPath.item == 0
        self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
        print("apply attributes: index \(layoutAttributes.indexPath.item), \(layoutAttributes.zIndex)")
    }
    
    // MARK: outlets -
    @IBOutlet weak var label: UILabel!
    
    // MARK: conform -
    func configure(_ item: DatasourceItem) {
        label.text = item.data
    }
}
