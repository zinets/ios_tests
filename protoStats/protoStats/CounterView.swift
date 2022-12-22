//
//  CounterView.swift
//  protoStats
//
//  Created by Victor Zinets on 19.12.2022.
//

import UIKit

class CounterView: UICollectionReusableView {
    
    // MARK: - outlets
    var cellType: FTStatProgressType = .like
    @IBOutlet var countLabel: UILabel! // FIXME: style
    @IBOutlet var typeLabel: UILabel?
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    private func commonSetup() {
        backgroundColor = .white
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(notifiction:)), name: .FTStatProgressCellFilled, object: nil)
    }
    
    private var isTransformed: Bool = false
    
    @objc private func updateView(notifiction: Notification) {
        if let data = notifiction.userInfo,
           let cellType = data["FTStatProgressType"] as? FTStatProgressType,
           cellType == self.cellType {
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1
                self.transform = .identity
                
                self.isTransformed = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    var selectionAction: (() -> Void)?
    
    @objc private func tapAction() {
        selectionAction?()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if !isTransformed {
            self.alpha = 0
            self.transform = .init(scaleX: 0, y: 0)
        }
    }
}
