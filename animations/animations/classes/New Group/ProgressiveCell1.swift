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

class StackCell: UICollectionViewCell, DiffAbleCell, SwipeableView {
    weak var delegate: SwipeableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(hue: CGFloat.random(in: 0..<1), saturation: 0.7, brightness: 1, alpha: 1)
        self.addGestureRecognizer(self.panRecognizer)
    }
    // не очень очевидная связка: есть протокол Swipable, которому конформит дефолтной реализацией pan recognizer; поэтому любой вью можно добавить стандартный пан рекогнайзер, все будет работать как обычно - пока в качестве селектора не передать метод из расширения - тогда жесты будут обрабатываться именно как смахивание карточки
    // красиво же
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let pr = UIPanGestureRecognizer(target: self, action: #selector(swipeCard(sender:)))
        return pr
    }()
    @objc func swipeCard(sender: UIPanGestureRecognizer) {
        // вот это место; или своя обработка какая-то - или готовая и затюненая для смахивания карточки
        sender.swipeView()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
//        self.panRecognizer.isEnabled = layoutAttributes.indexPath.item == 0
//        self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
//        print("index \(layoutAttributes.indexPath.item), z-order \(layoutAttributes.zIndex)")
    }
    
    // MARK: outlets -
    @IBOutlet weak var label: UILabel!
    
    // MARK: conform -
    func configure(_ item: DatasourceItem) {
        label.text = item.data
    }
}
