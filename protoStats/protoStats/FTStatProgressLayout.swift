//
//  FTStatProgressLayout.swift
//  protoStats
//
//  Created by Victor Zinets on 18.12.2022.
//

import UIKit

class BigCounterView: CounterView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 4
    }
    
}

class CounterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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

protocol ProgressLayoutDatasource: AnyObject {
    func progress(for index: Int) -> CGFloat
}

class FTStatProgressLayout: UICollectionViewLayout {
    
    static let CounterDecorationKind = "counterDecorationKind"
    static let BigCounterDecorationKind = "bigcounterDecorationKind"
    
    override init() {
        super.init()
        registerSupplementaries()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerSupplementaries()
    }
    
    private func registerSupplementaries() {
        register(CounterView.self, forDecorationViewOfKind: FTStatProgressLayout.CounterDecorationKind)
        register(CounterView.self, forDecorationViewOfKind: FTStatProgressLayout.BigCounterDecorationKind)
    }
    
    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    
    weak var progressDatasource: ProgressLayoutDatasource?
    
    var selection: Int? {
        didSet {
            invalidateLayout()
        }
    }
    
    override func prepare() {
        guard
            let collection = collectionView,
            let datasource = progressDatasource,
            collection.numberOfSections == 1,
            collection.numberOfItems(inSection: 0) >= 3
        else { return }
        cachedAttributes.removeAll(keepingCapacity: true)
        
        var frame = collection.bounds
        
        for index in 0..<collection.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attrs.frame = frame
            cachedAttributes.append(attrs)
            
            let kind = selection == index ? FTStatProgressLayout.BigCounterDecorationKind : FTStatProgressLayout.CounterDecorationKind
            
            let counterAttrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
            let distance = frame.height / 2 - strokeWidth / 2
            let angle = 2 * CGFloat.pi * datasource.progress(for: indexPath.item)
            
            let size = selection == index ? 40 : 25
            counterAttrs.frame = CGRect(x: 0, y: 0, width: size, height: size)
            counterAttrs.center = CGPoint(x: collection.center.x + distance * sin(angle),
                                          y: collection.center.y + distance * cos(angle))
            counterAttrs.zIndex = selection == index ? 100 : (90 - index)
            cachedAttributes.append(counterAttrs)
            
            frame = frame.insetBy(dx: strokeWidth + spacing, dy: strokeWidth + spacing)
        }
    }
    
    // MARK: - design
    var spacing: CGFloat = 2 {
        didSet {
            invalidateLayout()
        }
    }
    var strokeWidth: CGFloat = 18 {
        // он точно меняется под экран // TODO: Device.is4inch etc
        didSet {
            invalidateLayout()
        }
    }
    
    
    // MARK: - overrides
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cachedAttributes // этот метод возвращает все типы атрибутов
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes.filter ({ $0.representedElementCategory == .decorationView })[indexPath.item]
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collection = collectionView else { return .zero }
        
        return collection.bounds.size
    }
    
}
