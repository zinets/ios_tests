//
//  ViewController.swift
//  protoStats
//
//  Created by Victor Zinets on 16.12.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statView.likes = FTStatProgressView.StatItem(maxValue: 10, value: 5)
        statView.matches = FTStatProgressView.StatItem(maxValue: 10, value: 10)
        statView.visitors = FTStatProgressView.StatItem(maxValue: 100, value: 0)
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = createLayout()
            collectionView.dataSource = self
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(343 / 375), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    

    var datasource = [
        "Benefit 1",
        "Benefit 2",
        "Benefit 3",
        "Benefit 4",
//        "Benefit 5",
    ]
    
    @IBOutlet var statView: FTStatProgressView!
    
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath)
        if let cell = cell as? TestCell {
            cell.label.text = datasource[indexPath.item]
            cell.button.setTitle(datasource[indexPath.item], for: .normal)
        }
        return cell
    }
}

