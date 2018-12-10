//
//  TapplNavigationBar.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

// кастомный навбар нужен для а) настройки внешнего вида (отключение разделительной линии и полупрозрачности) и б) сохранения навбар итемов при пушах/попах

class TapplNavigationBar: UINavigationBar {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    private func commonInit() {
        self.isTranslucent = false
        shadowImage = UIImage()
    }
    
    override func pushItem(_ item: UINavigationItem, animated: Bool) {
        // do nothing
    }
    
}

extension TapplNavigationBar: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return TapplPushAnimator()
        case .pop:
            return TapplPopAnimator()
        default:
            return nil
        }
    }
}
