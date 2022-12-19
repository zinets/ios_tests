//
//  CounterView.swift
//  protoStats
//
//  Created by Victor Zinets on 19.12.2022.
//

import UIKit

class CounterView: UICollectionReusableView {
    
    // MARK: - outlets
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
        
    }
}
