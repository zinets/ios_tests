//
//  HeartIndicatorView.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 1/8/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

/// такая хрень круглая с сердечком внутри, счетчиком от 0 до 3 и обводкой, которая заполняется тоже от 0 до 3
// сердчко должно лежать в ассетах с именем heardCardIndicator
class HeartIndicatorView: UIView {

    // 0 - 3 (включительно; хз что означают числа..)
    var counterValue: Int = 0 {
        didSet {
            counterLabel.textColor = counterValue > 0 ? activeLabelColor : inactiveLabelColor
            counterLabel.text = String(counterValue)
            shapeLayer.strokeEnd = CGFloat(counterValue) / 3.0
        }
    }
    
    private let inactiveLabelColor: UIColor = UIColor(rgb: 0xb2b2b2)
    private let activeLabelColor: UIColor = UIColor.black
    
    private let strokeColor: UIColor = UIColor(rgb: 0xb2b2b2)
    private let activeStrokeColor: UIColor = UIColor(rgb: 0xfc6f54)
    
    private var counterLabel: UILabel!
    private var shapeLayer: CAShapeLayer!
    private var bgShapeLayer: CAShapeLayer!
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    private func commonSetup() {
        self.clipsToBounds = false
        self.backgroundColor = .clear
        
        let heartImage = UIImageView(image: UIImage(named: "heardCardIndicator"))
        heartImage.translatesAutoresizingMaskIntoConstraints = false
        heartImage.contentMode = .center
        self.addSubview(heartImage)
        NSLayoutConstraint.activate([
            heartImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            heartImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            heartImage.heightAnchor.constraint(equalTo: self.heightAnchor),
            heartImage.widthAnchor.constraint(equalTo: heartImage.heightAnchor)
        ])
        
        counterLabel = UILabel()
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        counterLabel.textColor = self.inactiveLabelColor
        counterLabel.text = "0"
        self.addSubview(counterLabel)
        NSLayoutConstraint.activate([
            counterLabel.centerYAnchor.constraint(equalTo: heartImage.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: heartImage.trailingAnchor, constant: 5)
        ])
        
        bgShapeLayer = CAShapeLayer()
        bgShapeLayer.frame = heartImage.bounds
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 2
        bgShapeLayer.lineCap = .round
        bgShapeLayer.strokeEnd = 1.0
        bgShapeLayer.strokeColor = self.strokeColor.cgColor
        heartImage.layer.addSublayer(bgShapeLayer)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.frame = heartImage.bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0.0
        shapeLayer.strokeColor = self.activeStrokeColor.cgColor
        shapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        heartImage.layer.addSublayer(shapeLayer)
        
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
        
        self.counterValue = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.height, height: self.bounds.size.height)
        let path = UIBezierPath(ovalIn: shapeLayer.bounds)
        path.lineWidth = 2
        path.lineCapStyle = .round
        shapeLayer.path = path.cgPath
        
        bgShapeLayer.frame = shapeLayer.frame
        bgShapeLayer.path = path.cgPath
    }
    
    // MARK: -
//    override func prepareForInterfaceBuilder() {
//        <#code#>
//    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var sz = self.frame.size
            sz.width = sz.height
            
            return sz
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
    
}
