//
//  StackCardsBaseCellView.swift
//  animations
//
//  Created by Viktor Zinets on 24.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class StackBaseCardView: UICollectionViewCell, SwipeableView, OverlayedView {
    
    // MARK: SwipeableView -
    weak var swipeDelegate: SwipeableDelegate?
       
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let pr = UIPanGestureRecognizer(target: self, action: #selector(swipeCard(sender:)))
        self.addGestureRecognizer(pr)
        return pr
    }()
    
    @objc func swipeCard(sender: UIPanGestureRecognizer) {
        sender.swipeView()
    }
    
    // MARK: OverlayedView -
    @IBOutlet weak var overlayView: UIView!
    
    @Restriction(0...1)
    var overlayOpacity: CGFloat = 0 {
        didSet {
            self.overlayView.alpha = overlayOpacity * 2
        }
    }
    
    // MARK: required overrides -
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layer.transform = CATransform3DIdentity

        self.overlayOpacity = 0
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        self.panRecognizer.isEnabled = layoutAttributes.indexPath.item == 0
    }
}
