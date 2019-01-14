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
        
        return imageView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    private let coloredView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    func commonInit() {
        // 1й слой - одноцветное сердце
        self.addSubview(shapeView)
        
        // 1й слой - это форма жопки; куча ограничителей: 1) центрирование по гориз. и вертикали 2) отступы по краям >= 0 чтобы не вылезать за края контрола 3) с приоритетом 750 равенство ширины и высоты контролу - чтобы фрейм контрола-жопки по одной стороне совпадал с шириной или высотой самого контрола 4) соотношение сторон из картинки жопки - 300:252
        
        var centerXC = shapeView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        var centerYC = shapeView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        let leadingC = shapeView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor)
        let topC = shapeView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor)
        let trailingC = shapeView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor)
        let bottomC = shapeView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        
        var widthC = shapeView.widthAnchor.constraint(equalTo: self.widthAnchor)
        widthC.priority = UILayoutPriority.init(749)
        var heightC = shapeView.heightAnchor.constraint(equalTo: self.heightAnchor)
        heightC.priority = UILayoutPriority.init(748)

        let ratioC = shapeView.heightAnchor.constraint(equalTo: shapeView.widthAnchor, multiplier: 252.0 / 300.0)
        ratioC.priority = UILayoutPriority.required
        
        NSLayoutConstraint.activate([
            ratioC,
            trailingC, topC, leadingC, bottomC,
            centerXC, centerYC,
            widthC, heightC,
        ])
        
        // 2й слой - вью с выверенными размерами и позицией, в котором будет контент
        self.addSubview(contentView)
        centerXC = contentView.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor)
        centerYC = contentView.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        widthC = contentView.widthAnchor.constraint(equalTo: shapeView.widthAnchor, multiplier: 200.0 / 295.0)
        heightC = contentView.heightAnchor.constraint(equalTo: shapeView.heightAnchor, multiplier: 128.0 / 210.0)
        NSLayoutConstraint.activate([
            centerXC, centerYC,
            widthC, heightC,
        ])
        
        // 3й слой - цветные элементы поверх текста если нужно
        self.addSubview(coloredView)
        coloredView.image = UIImage(named: "blueHearts")
        centerXC = coloredView.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor)
        centerYC = coloredView.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        widthC = coloredView.widthAnchor.constraint(equalTo: shapeView.widthAnchor)
        heightC = coloredView.heightAnchor.constraint(equalTo: shapeView.heightAnchor)
        NSLayoutConstraint.activate([
            centerXC, centerYC,
            widthC, heightC,
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
