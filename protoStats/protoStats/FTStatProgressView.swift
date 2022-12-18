//
//  FTStatProgressView.swift
//  protoStats
//
//  Created by Victor Zinets on 18.12.2022.
//

import UIKit

class FTStatProgressView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - datasource
    var datasource: [FTStatProgressType: (value: Int, maxValue: Int)] = [
        .like: (1, 10),
        .watch: (16, 21),
        .match: (10, 10),
    ]
    
        
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
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        
        collectionView.register(FTStatProgressCell.self, forCellWithReuseIdentifier: "FTStatProgressCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension FTStatProgressView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 3 }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FTStatProgressCell", for: indexPath)
        if let cell = cell as? FTStatProgressCell {
            let cellType = FTStatProgressType(rawValue: indexPath.item) ?? .like
            cell.cellType = cellType
            cell.maxProgress = datasource[cellType]?.maxValue ?? 0
            cell.progressValue = datasource[cellType]?.value ?? 0
        }
        return cell
    }
}
