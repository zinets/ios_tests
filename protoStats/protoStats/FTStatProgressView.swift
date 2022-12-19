//
//  FTStatProgressView.swift
//  protoStats
//
//  Created by Victor Zinets on 18.12.2022.
//

import UIKit

extension FTStatProgressView: ProgressLayoutDatasource {
    
    func progress(for index: Int) -> CGFloat {
        let cellType = datasource[index]
        guard            
            let data = values[cellType]
        else { fatalError() }
        
        return CGFloat(data.value) / CGFloat(data.maxValue)
    }
    
}

class FTStatProgressView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - datasource
    var datasource: [FTStatProgressType] = [ .visitor, .like, .match]
    
    struct StatItem {
        var maxValue: Int
        var value: Int
        var isSelected: Bool = false // хз
    }
    
    private var values: [FTStatProgressType: StatItem] = [:]
    
    var likes: StatItem? {
        get { values[.like] }
        set {
            values[.like] = newValue
            collectionView.reloadData()
        }
    }
    var matches: StatItem? {
        get { values[.match] }
        set {
            values[.match] = newValue
            collectionView.reloadData()
        }
    }
    var visitors: StatItem? {
        get { values[.visitor] }
        set {
            values[.visitor] = newValue            
            collectionView.reloadData()
        }
    }
    
    
        
    // MARK: - outlets
    private var collectionView: UICollectionView!
    
    // MARK: -
    private func setupUI() {
        let iv = UIImageView(image: UIImage(named: "statBlur"))
        // красивое сияние под этим всем; могут быть проблемыв из-за того что оно а) имеет свой фон б) вылезает за границы контрола
        iv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iv)
        NSLayoutConstraint.activate([
            iv.leftAnchor.constraint(equalTo: leftAnchor),
            iv.rightAnchor.constraint(equalTo: rightAnchor),
            iv.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: 131 / 220),
            iv.topAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        let layout = FTStatProgressLayout()
        layout.spacing = 2
        layout.strokeWidth = 18
        layout.progressDatasource = self
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear // потому что снизу блур должен "просвещаться"
        collectionView.clipsToBounds = false // потому что каунтеры могут и будут вылезать за границу
        addSubview(collectionView)
        
        collectionView.register(FTStatProgressCell.self, forCellWithReuseIdentifier: "FTStatProgressCell")
        collectionView.register(UINib(nibName: "CounterView", bundle: nil), forSupplementaryViewOfKind: FTStatProgressLayout.CounterDecorationKind, withReuseIdentifier: "CounterView")
        collectionView.register(UINib(nibName: "BigCounterView", bundle: nil), forSupplementaryViewOfKind: FTStatProgressLayout.BigCounterDecorationKind, withReuseIdentifier: "BigCounterView")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 3 }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FTStatProgressCell", for: indexPath)
        if let cell = cell as? FTStatProgressCell {
            let cellType = datasource[indexPath.item]
            cell.cellType = cellType
            if let values = values[cellType] {
                cell.maxProgress = values.maxValue
                cell.progressValue = values.value
            }
        }
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reuseId = kind == FTStatProgressLayout.BigCounterDecorationKind ? "BigCounterView" : "CounterView"
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseId, for: indexPath)
        if let view = view as? CounterView {
            view.selectionAction = { 
                if let layout = collectionView.collectionViewLayout as? FTStatProgressLayout {
                    layout.selection = layout.selection == indexPath.item ? nil : indexPath.item
                }
            }
            let cellType = datasource[indexPath.item]
            if let values = values[cellType] {
                view.countLabel.text = String(values.value)
                view.typeLabel?.text = cellType.counterText(usePlural: values.value > 1)
            }
            
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
