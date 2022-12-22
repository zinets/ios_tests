//
//  FTStatProgressCell.swift
//  protoStats
//
//  Created by Victor Zinets on 18.12.2022.
//

import UIKit

extension Notification.Name {
    static let FTStatProgressCellFilled = Notification.Name("FTStatProgressCellFilled")
}

class FTStatProgressCell: UICollectionViewCell {
    
    var cellType: FTStatProgressType = .like {
        didSet {
            typeIconView.image = cellType.iconImage
            progressLayer.colors = cellType.gradientColors.map { $0.cgColor }
        }
    }
    
    var maxProgress: Int = 21 {
        didSet {
            updateProgress()
        }
    }
    
    var progressValue: Int = 0 {
        didSet {
            updateProgress(animated: true)
        }
    }
    
    private func updateProgress(animated: Bool = false) {
        let p = CGFloat(progressValue) / CGFloat(maxProgress)
        if !animated {
            progressMaskLayer.strokeEnd = p
            fullIconView.isHidden = p < 1
            typeIconView.isHidden = p == 1
        } else {
            let delay = p * 0.8 // ну пусть типа 0,8 сек это заполнение до 1
            let a1 = CABasicAnimation(keyPath: "strokeEnd")
            a1.duration = delay
            a1.toValue = p
            a1.isRemovedOnCompletion = false
            a1.fillMode = .forwards
            progressMaskLayer.add(a1, forKey: "appearing")
            
            fullIconView.isHidden = false
            typeIconView.isHidden = false
            fullIconView.alpha = 0
            typeIconView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: delay, options: []) {
                self.fullIconView.alpha = p < 1 ? 0 : 1
                self.typeIconView.alpha = p == 1 ? 0 : 1
            } completion: { _ in
                self.fullIconView.isHidden = p < 1
                self.typeIconView.isHidden = p == 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * 0.7) {
                NotificationCenter.default.post(name: .FTStatProgressCellFilled, object: nil,
                                                userInfo: ["FTStatProgressType": self.cellType])
            }

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
    
    private func setupUI() {
        backgroundColor = .clear
        
        layer.addSublayer(bgLayer)
        layer.addSublayer(progressLayer)
        addSubview(typeIconView)
        
        let bottomSpace = strokeWidth * 0.3334 / 2
        iconBottom = typeIconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomSpace)
        NSLayoutConstraint.activate([
            iconWidth!, iconHeight!,
            iconBottom!,
            typeIconView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        addSubview(fullIconView)
        NSLayoutConstraint.activate([
            fullIconView.centerXAnchor.constraint(equalTo: typeIconView.centerXAnchor),
            fullIconView.centerYAnchor.constraint(equalTo: typeIconView.centerYAnchor),
            fullIconView.widthAnchor.constraint(equalTo: typeIconView.widthAnchor),
            fullIconView.heightAnchor.constraint(equalTo: typeIconView.heightAnchor),
        ])
    }
    
    // MARK: - outlets
    private var iconWidth: NSLayoutConstraint?
    private var iconHeight: NSLayoutConstraint?
    private var iconBottom: NSLayoutConstraint?
    
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
    
    private lazy var fullIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "statFullCheck"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()
    
    
       
}

