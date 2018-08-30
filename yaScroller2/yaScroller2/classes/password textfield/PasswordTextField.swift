//
//  PasswordTextField.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class PasswordTextField: UITextField {
    
    func commonInit() {
        isSecureTextEntry = true
        let showSymbolsButton = UIButton(type: .custom)
        
        showSymbolsButton.frame = CGRect(origin: CGPoint.zero,
                                         size: CGSize(width: self.bounds.size.height,
                                                      height: self.bounds.size.height))
        showSymbolsButton.setImage(UIImage(named: "showSymbols"), for: UIControlState.selected)
        showSymbolsButton.setImage(UIImage(named: "hideSymbols"), for: UIControlState.normal)
        showSymbolsButton.addTarget(self, action: #selector(showSymbols(_:)), for: .touchUpInside)
        
        rightView = showSymbolsButton
        rightViewMode = .whileEditing
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @objc private func showSymbols(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = !sender.isSelected

        // мажик: если шрифт не моноширинный, то после перехода secured -> non-secured курсор остается в прежней позиции, а длина текста 99% будет меньше, чем длина "точек", маскирующих введенный текст, визуальная херня
        self.resignFirstResponder()
        self.becomeFirstResponder()
    }
}
