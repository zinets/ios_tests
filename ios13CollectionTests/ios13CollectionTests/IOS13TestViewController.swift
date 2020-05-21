//
//  ViewController.swift
//  ios13CollectionTests
//
//  Created by Viktor Zinets on 21.05.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class IOS13TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: collection layout -
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = self.createLayout()
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, env) -> NSCollectionLayoutSection? in
            let section = self.sectionFor(section: section)
            return section
        }, configuration: config)
        
        return layout
    }
    
    
    
    func sectionFor(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            return section1()
        case 1:
            return section2()
        default:
            fatalError()
        }
    }
        
    func section1() -> NSCollectionLayoutSection {
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                     heightDimension: .fractionalWidth(0.5))
        let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
        
        let smallSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallSize)
        
        let smallItemsGroup = NSCollectionLayoutGroup.vertical(layoutSize:
            NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                   heightDimension: .fractionalHeight(1)),
                                                               subitem: smallItem,
                                                               count: 2)
        
        let trailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
            NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                   heightDimension: .fractionalHeight(1)),
                                                               subitems: [smallItemsGroup])
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                   heightDimension: .fractionalWidth(0.5)),
                                                       subitems: [leadingItem, trailingGroup])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func section2() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(44)) // <----- тут
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(44)) // <----- И тут !!!
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
}

private typealias CollectionDataSource = IOS13TestViewController
extension CollectionDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            
            return cell
        default:
            fatalError()
        }
    }
    
    
}
