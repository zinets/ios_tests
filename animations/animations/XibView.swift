//
//  XibView.swift
//  вью, загружаемое из xib
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

protocol XibView where Self: UIView { }

extension XibView {
    
    func loadFromXib<T: UIView>() -> T {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Cannot instantiate a UIView from the nib for class \(type(of: self))")
        }
        return view
    }
    
    func setupInternalView() {
        let viewFromXib = loadFromXib()
        viewFromXib.frame = self.bounds
        viewFromXib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(viewFromXib)
        // или по-новому
//        viewFromXib.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            viewFromXib.leftAnchor.constraint(equalTo: self.leftAnchor),
//            viewFromXib.rightAnchor.constraint(equalTo: self.rightAnchor),
//            viewFromXib.topAnchor.constraint(equalTo: self.topAnchor),
//            viewFromXib.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//        ])
    }
}
