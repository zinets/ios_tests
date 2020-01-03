//
//  RemainCounterView.swift
//  remainCounterProto
//
//  Created by Viktor Zinets on 03.01.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

/// счетчик оставшегося кол-ва вводимых символов для UFD для заполнения полей в профиле (about); для простоты надо следить, чтобы контрол был квадратным, иначе надо допиливать код
class UFDRemainCounterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    // MARK: public -
    /// введенное кол-во символов
    var count: Int = 0 {
        didSet {
            guard count != oldValue else { return }
            self.updateRemain()
        }
    }
    /// максимальное кол-во скажем символов, которое можно ввести
    var maxCount: Int = 100 {
        didSet {
            self.updateRemain()
        }
    }
        
    // MARK: outlets etc -
    private var textLabel: UILabel!
    private var progressLayer: CAShapeLayer!
    private var bgLayer: CAShapeLayer!
    
    // MARK: internal -
    private let normalTextColor = UIColor.black
    private let criticalTextColor = UIColor(red: 0.878, green: 0.125, blue: 0.357, alpha: 1)
    private let warningTextColor = UIColor(red: 1.0, green: 0.55, blue: 0.31, alpha: 1)
    private let normalColor = UIColor(red: 0, green: 0.7, blue: 0.48, alpha: 1)
    private let shapeBgColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
    
    private let textVisibilitiCount = 20
    private let warningVisibilityPercent: CGFloat = 0.6
    
    private func commonInit() {
        self.backgroundColor = .white
        
        textLabel = UILabel()
        textLabel.text = "100"
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            textLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
        ])
        
        bgLayer = CAShapeLayer()
        bgLayer.strokeColor = self.shapeBgColor.cgColor
        bgLayer.fillColor = UIColor.clear.cgColor
        let strokePath = UIBezierPath(ovalIn: self.bounds)
        strokePath.lineWidth = 2
        bgLayer.path = strokePath.cgPath
        self.layer.addSublayer(bgLayer)
        
        progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        
        var t = CATransform3DIdentity
        t = CATransform3DTranslate(t, 0, self.bounds.size.height, 0)
        t = CATransform3DRotate(t, -CGFloat.pi / 2, 0, 0, 1)
        progressLayer.transform = t
        
        self.layer.addSublayer(progressLayer)
        
        self.updateRemain()
    }
    
    private func updateRemain() {
        let remain = max(0, self.maxCount - self.count)
        
        // text
        textLabel.text = String(remain)
        textLabel.textColor = remain == 0 ? criticalTextColor : normalTextColor
        textLabel.isHidden = remain >= textVisibilitiCount
        
        // stroke
        let strokePath = UIBezierPath(ovalIn: self.bounds)
        strokePath.lineWidth = 2
        progressLayer.path = strokePath.cgPath
        
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(self.count) / CGFloat(self.maxCount)
        
        if self.count > self.maxCount - textVisibilitiCount {
            progressLayer.strokeColor = self.criticalTextColor.cgColor
        } else if CGFloat(self.count) > CGFloat(self.maxCount) * warningVisibilityPercent {
            progressLayer.strokeColor = self.warningTextColor.cgColor
        } else {
            progressLayer.strokeColor = self.normalColor.cgColor
        }
    }

}
