//
//  FTStatProgressCell.swift
//  protoStats
//
//  Created by Victor Zinets on 18.12.2022.
//

import UIKit

class FTStatProgressCell: UICollectionViewCell {
    
    var cellType: FTStatProgressType = .like {
        didSet {
            typeIconView.image = cellType.iconImage
            progressLayer.colors = cellType.gradientColors.map { $0.cgColor }
        }
    }
    
    var maxProgress: Int = 21 {
        didSet {
            progressMaskLayer.strokeEnd = CGFloat(progressValue) / CGFloat(maxProgress)
        }
    }
    
    var progressValue: Int = 0 {
        didSet {
            let p = CGFloat(progressValue) / CGFloat(maxProgress)
            progressMaskLayer.strokeEnd = p
            
            counterGroup.isHidden = progressValue == 0
            counterLabel.text = String(progressValue)
            
            let a = CGFloat.pi * 2 * p
            let lenght = bounds.height / 2 - strokeWidth / 2
            counterX?.constant = lenght * sin(a)
            counterY?.constant = lenght * cos(a)
        }
    }
    
    var strokeWidth: CGFloat = 18 {
        didSet {
            let size = strokeWidth * 0.6666
            iconWidth?.constant = size
            iconHeight?.constant = size
            let offset = (strokeWidth - size) / 2
            iconBottom?.constant = -offset
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override var isSelected: Bool {
        didSet {
            if !isSelected {
                typeLabel.text = ""
                typeLabel.isHidden = true
            } else {
                typeLabel.text = cellType.counterText(usePlural: progressValue > 1)
                typeLabel.isHidden = false
            }
        }
    }
    
    private func setupUI() {
        
        backgroundColor = .clear
        
        layer.addSublayer(bgLayer)
        layer.addSublayer(progressLayer)
        
        addSubview(typeIconView)
        addSubview(counterGroup)
        counterX = counterGroup.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        counterY = counterGroup.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        NSLayoutConstraint.activate([ counterX!, counterY! ])
        
        let bottomSpace = strokeWidth * 0.3334 / 2
        iconBottom = typeIconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomSpace)
        NSLayoutConstraint.activate([
            iconWidth!, iconHeight!,
            iconBottom!,
            typeIconView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    // MARK: - outlets
    private var iconWidth: NSLayoutConstraint?
    private var iconHeight: NSLayoutConstraint?
    private var iconBottom: NSLayoutConstraint?
    private var counterX: NSLayoutConstraint?
    private var counterY: NSLayoutConstraint?
    
    private lazy var bgLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        
        layer.strokeColor = UIColor.white.withAlphaComponent(0.1).cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = strokeWidth
        
        let frame = self.bounds.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
        let path = UIBezierPath(ovalIn: frame)
        layer.path = path.cgPath
        
        return layer
    }()
    
    private lazy var progressMaskLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineWidth = strokeWidth
        maskLayer.lineCap = .round
        
        maskLayer.strokeStart = 0
        maskLayer.strokeEnd = 0
        
        var transform = CATransform3DRotate(CATransform3DIdentity, CGFloat.pi / 2, 0, 0, 1)
        transform = CATransform3DScale(transform, 1, -1, 1)
        maskLayer.transform = transform
        
        return maskLayer
    }()
    
    private lazy var progressLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = FTStatProgressType.like.gradientColors.map { $0.cgColor }
        layer.frame = bounds
        
        let frame = self.bounds.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
        let path = UIBezierPath(ovalIn: frame)
        progressMaskLayer.frame = bounds
        progressMaskLayer.path = path.cgPath
   
        layer.mask = progressMaskLayer
        return layer
    }()
    
    private lazy var typeIconView: UIImageView = {
        let iv = UIImageView(image: FTStatProgressType.like.iconImage)
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let iconSize = strokeWidth * 0.6666
        iconWidth = iv.widthAnchor.constraint(equalToConstant: iconSize)
        iconHeight = iv.widthAnchor.constraint(equalToConstant: iconSize)
                
        return iv
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        label.font = UIFont.systemFont(ofSize: 14) // TODO: style
        label.textColor = .black // TODO: style
        label.text = "2"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var typeLabel: UILabel = { // "2 matches"
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10) // TODO: style
        label.textColor = .lightGray // TODO: style
        label.text = "Maches"
        label.isHidden = true
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            counterLabel,
            typeLabel,
        ])
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = .orange.withAlphaComponent(0.2)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var counterGroup: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let circle = UIImageView(image: UIImage(named: "statCounterBg"))
        circle.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        circle.frame = view.bounds
        view.addSubview(circle)
        
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            vStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.heightAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }()
}
