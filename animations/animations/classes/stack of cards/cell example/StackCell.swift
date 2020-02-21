//
//  StackCell.swift
//  animations
//
//  Created by Viktor Zinets on 21.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

// just as example
protocol LikeBookCellDelegate: class {
    func didSomeAction()
}

class StackCell: UICollectionViewCell, DiffAbleCell, SwipeableView {

    weak var actionDelegate: LikeBookCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(hue: CGFloat.random(in: 0..<1), saturation: 0.7, brightness: 1, alpha: 1)
        self.addGestureRecognizer(self.panRecognizer)
    }
    
    
    // MARK: поддержка "смахивательности" -
    // это просто ссылка на кого-то "вверху" (например контроллер), которому просигналим: что-то произошло
    weak var swipeDelegate: SwipeableDelegate?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // т.к. смахивание делается трансформом слоя, то где-то кому-то надо восстановить трансформ, почему не тут (если смахивание отменилось, трансформ восстановится в обработчике панРекогнайзера
        self.layer.transform = CATransform3DIdentity
    }
    
    // MARK: -
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.panRecognizer.isEnabled = layoutAttributes.indexPath.item == 0
        
        // эта строчка решает проблему с визуальным порядком ячеек в стопке; но - не решает с фактическим и обработкой ивентов
//        self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
//        print("index \(layoutAttributes.indexPath.item), z-order \(layoutAttributes.zIndex)")
    }
    
    
    
    // MARK: outlets -
    @IBOutlet weak var label: UILabel!
    
    @IBAction func buttonAction(_ sender: Any) {
        if let delegate = self.actionDelegate {
            delegate.didSomeAction()
        }
    }
    
    // MARK: conform -
    func configure(_ item: DatasourceItem) {
        label.text = item.data
    }
}
