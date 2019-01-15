//
//  TappleHeartBaseControl.swift
//  unblurTest
//
//  Created by Victor Zinets on 1/14/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

//@IBDesignable
class TappleHeartBaseControl: UIView {
    
    private let shapeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.black
        view.clipsToBounds = true
        return view
    }()
    
    @IBOutlet var contentView: UIView!       = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let coloredView: UIImageView = {
        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let heartMaskView: UIImageView = {
         return UIImageView(image: UIImage(named: "heartShape"))
    }()
    
    var heartImage: String = "" {
        didSet {
            let image = UIImage(named: heartImage)
            self.coloredView.image = image
        }
    }
    override var backgroundColor: UIColor? {
        set {
            shapeView.backgroundColor = newValue
            super.backgroundColor = .clear
        }
        get {
            return shapeView.backgroundColor
        }
    }
    
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

        let ratioC = shapeView.heightAnchor.constraint(equalTo: shapeView.widthAnchor, multiplier: 252.0 / 299.0)
        ratioC.priority = UILayoutPriority.required
        
        NSLayoutConstraint.activate([
            ratioC,
            trailingC, topC, leadingC, bottomC,
            centerXC, centerYC,
            widthC, heightC,
        ])
        
        // 2й слой - вью с выверенными размерами и позицией, в котором будет контент
        shapeView.addSubview(contentView) // внутри shapeView - чтобы отслеживать размер!
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
//        centerXC = coloredView.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor)
//        centerYC = coloredView.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
//        widthC = coloredView.widthAnchor.constraint(equalTo: shapeView.widthAnchor)
//        heightC = coloredView.heightAnchor.constraint(equalTo: shapeView.heightAnchor)
//        NSLayoutConstraint.activate([
//            centerXC, centerYC,
//            widthC, heightC,
//        ])
        
        self.mask = heartMaskView
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heartMaskView.frame = shapeView.frame
        coloredView.frame = shapeView.frame // может быть так точнее совпадает обрезанный маской фон и накладываемый сверху декор?.. чем ресайз лайоутами
        
        self.layoutIfNeeded()
    }


//    было бы хорошо, но х*й вам - в ib нихера не отрисовывается
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//
//        self.backgroundColor = UIColor.yellow
//        self.heartImage = "blueHearts"
//    }
   
   
}
