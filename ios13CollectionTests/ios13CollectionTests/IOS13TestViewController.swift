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
            let section = NSCollectionLayoutSection(group: self.groupFor(section: section))
            return section
        }, configuration: config)
        
        return layout
    }
    
    
    
    func groupFor(section: Int) -> NSCollectionLayoutGroup {
        switch section {
        case 0: return group1()
        default: return group1()
        }
    }
        
    func group1() -> NSCollectionLayoutGroup {
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                     heightDimension: .fractionalWidth(0.5))
        let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
        leadingItem.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let size2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .fractionalWidth(0.5))
        let item2 = NSCollectionLayoutItem(layoutSize: size2)
        item2.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)

        let trailingItemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                       heightDimension: .fractionalHeight(1))
        let trailingSubGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingItemsSize,
                                                                subitem: item2,
                                                                count: 2)
        let trailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
            NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                   heightDimension: .fractionalHeight(1)),
                                                               subitem: trailingSubGroup,
                                                               count: 2)
        
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [leadingItem, trailingGroup])
        return group
    }
}

private typealias CollectionDataSource = IOS13TestViewController
extension CollectionDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0, 1, 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            
            return cell
        default:
            fatalError()
        }
    }
    
    
}
