//
//  TappleHeartBaseControl.swift
//  unblurTest
//
//  Created by Victor Zinets on 1/14/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class TappleHeartBaseControl: UIView {

    private let shapeView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "heartShape"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
//        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: NSLayoutConstraint.Axis.horizontal)
//        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: NSLayoutConstraint.Axis.vertical)
        return imageView
    }()
    
    func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(shapeView)
        
        // 1й слой - это форма жопки; куча ограничителей: 1) центрирование по гориз. и вертикали 2) отступы по краям >= 0 чтобы не вылезать за края контрола 3) с приоритетом 750 равенство ширины и высоты контролу - чтобы фрейм контрола-жопки по одной стороне совпадал с шириной или высотой самого контрола 4) соотношение сторон из картинки жопки - 300:252
        
        let centerXC = shapeView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerYC = shapeView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        let leadingC = shapeView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor)
        let trailingC = shapeView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor)
        let topC = shapeView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor)
        let bottomC = shapeView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        
        let widthC = shapeView.widthAnchor.constraint(equalTo: self.widthAnchor)
        widthC.priority = UILayoutPriority.init(749)
        let heightC = shapeView.heightAnchor.constraint(equalTo: self.heightAnchor)
        heightC.priority = UILayoutPriority.init(748)

        let ratioC = shapeView.heightAnchor.constraint(equalTo: shapeView.widthAnchor, multiplier: 252.0 / 300.0)
        ratioC.priority = UILayoutPriority.required
        
        NSLayoutConstraint.activate([
            ratioC,
            trailingC,
            topC,
            leadingC,
            bottomC,
            centerXC,
            centerYC,
            widthC,
            heightC,
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}
