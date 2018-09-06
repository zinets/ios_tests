//
//  ItemView.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/6/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

enum ItemState {
    case none
    case small
    case medium
    case normal
    case active
}

/// это "контрол", который используется в "пейджконтроле-как-у-инстаграма" для показа точечек; т.о. можно разноображивать дизайн как угодно (в датасорсе пейджера запрашивается вью для индекса и в том месте можно возвращать разные по дизайну варианты "точечки" - например "+" для страницы загрузки или |> для видео)
class IPageControlItem: UIView {

    fileprivate var itemSize: CGFloat = 0
    fileprivate var dotSize: CGFloat = 0
    
    fileprivate var dotView: UIView?
    
    var index: Int = 0
    var state: ItemState = .normal {
        didSet {
            self.updateDotSize(state)
        }
    }
    var animationDuration: TimeInterval = 0.25
    
    init(_ newItemSize: CGFloat, dotSize: CGFloat, newIndex: Int) {
        
        let x = newItemSize * CGFloat(newIndex)
        let frame = CGRect(x: x, y: 0, width: newItemSize, height: newItemSize)
        super.init(frame: frame)
        
        self.state = .normal
        self.itemSize = newItemSize
        self.dotSize = dotSize
        self.index = newIndex
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateDotSize(_ state: ItemState) {
        
    }
    
    class func dotMarkView(_ dotSize: CGFloat) -> UIView {
        let dot2 = UIView(frame: CGRect(x: 0, y: 0, width: dotSize, height: dotSize))
        dot2.backgroundColor = UIColor.clear
        dot2.layer.borderColor = UIColor.white.cgColor
        dot2.layer.borderWidth = 1;
        
        return dot2
    }
}

class IPageControlDotItem: IPageControlItem {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(_ newItemSize: CGFloat, dotSize: CGFloat, newIndex: Int) {
        super.init(newItemSize, dotSize: dotSize, newIndex: newIndex)
        
        dotView = IPageControlItem.dotMarkView(dotSize)
        dotView!.center = CGPoint(x: newItemSize / 2, y: newItemSize / 2)
        dotView!.layer.cornerRadius = dotSize / 2
        dotView!.layer.masksToBounds = true
        
        self.addSubview(dotView!)
    }
    
    override func updateDotSize(_ state: ItemState) {
        if let view = dotView {
            var sz: CGSize
            view.backgroundColor = UIColor.clear
            switch state {
            case .active:
                sz = CGSize(width: dotSize, height: dotSize)
                view.backgroundColor = UIColor.white
            case .normal:
                sz = CGSize(width: dotSize, height: dotSize)
            case .medium:
                sz = CGSize(width: dotSize * 0.75, height: dotSize * 0.75)
            case .small:
                sz = CGSize(width: dotSize * 0.5, height: dotSize * 0.5)
            case .none:
                sz = CGSize.zero
            }
            
            var frm = view.bounds
            
            let ga = CAAnimationGroup()
            ga.duration = animationDuration
            
            let a1 = CABasicAnimation(keyPath: "cornerRadius")
            a1.fromValue = view.layer.cornerRadius
            a1.toValue = sz.height / 2
            a1.duration = ga.duration
            
            let a2 = CABasicAnimation(keyPath: "bounds")
            a2.fromValue = frm
            frm.size = sz
            a2.toValue = frm
            a2.duration = ga.duration
            
            let a3 = CABasicAnimation(keyPath: "opacity")
            a3.fromValue = view.layer.opacity
            view.layer.opacity = state == .none ? 0 : 1
            a3.toValue = view.layer.opacity
            a3.duration = ga.duration
            
            
            ga.animations = [a1, a2, a3]
            view.layer.add(ga, forKey: "ga")
            
            view.layer.bounds = frm
            view.layer.cornerRadius = sz.height / 2
        }
    }
}
