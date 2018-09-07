//
//  ItemView.swift
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
    
    static var mediumSizeRatio: CGFloat = 0.7
    
    static var smallSizeRatio: CGFloat = 0.5
    
    var index: Int
    
    var dotColor = UIColor.lightGray {
        didSet {
            dotView.backgroundColor = dotColor
        }
    }
    
    var state: ItemState = .normal {
        didSet {
            updateDotSize(state: state)
        }
    }
    
    var animateDuration: TimeInterval = 0.3
    
    init(itemSize: CGFloat, dotSize: CGFloat, index: Int) {
        
        self.itemSize = itemSize
        self.dotSize = dotSize
        self.index = index
        
        let x = itemSize * CGFloat(index)
        let frame = CGRect(x: x, y: 0, width: itemSize, height: itemSize)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        dotView.frame.size = CGSize(width: dotSize, height: dotSize)
        dotView.center = CGPoint(x: itemSize/2, y: itemSize/2)
        dotView.backgroundColor = dotColor
        dotView.layer.cornerRadius = dotSize/2
        dotView.layer.masksToBounds = true
        
        addSubview(dotView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    // MARK: private
    private let dotView = UIView()
    
    private let itemSize: CGFloat
    
    private let dotSize: CGFloat
    
    private func updateDotSize(state: ItemState) {
        
        var _size: CGSize
        
        switch state {
        case .normal, .active:
            _size = CGSize(width: dotSize, height: dotSize)
        case .medium:
            _size = CGSize(width: dotSize * IPageControlItem.mediumSizeRatio, height: dotSize * IPageControlItem.mediumSizeRatio)
        case .small:
            _size = CGSize(
                width: dotSize * IPageControlItem.smallSizeRatio,
                height: dotSize * IPageControlItem.smallSizeRatio
            )
        case .none:
            _size = CGSize.zero
        }
        
        dotView.layer.cornerRadius = _size.height / 2.0
        
        UIView.animate(withDuration: animateDuration, animations: { [unowned self] in
            self.dotView.layer.bounds.size = _size
        })
    }
}
