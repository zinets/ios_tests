//
//  YellowController.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class YellowController: UIViewController {

    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.scrollDirection = .horizontal
            let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
            
            collectionView.collectionViewLayout = layout
        }
    }
    
    private lazy var dataSource = CollectionDiffAbleDatasource<DiffAbleSection, AnyDiffAble>(collectionView: self.collectionView) { ($0 as! AnyDiffAbleControl).configure($1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.transitioningDelegate
        
        update()
    }
    
    func update() {
        dataSource.beginUpdates()
        dataSource.appendSections([.single])
        let items = ["first page", "second page", "last page"].map { (text) -> AnyDiffAble in
            let item = ContentItem(text: text)
            return AnyDiffAble(item)
        }
        dataSource.appendItems(items, toSection: .single)
        dataSource.endUpdates(false)
    }
}


extension YellowController: Transitionable {
    
    var view1: UIView? {
        return self.view
    }
    
    
}
