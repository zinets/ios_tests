//
//  ViewController.swift
//  ios13CollectionTests
//
//  Created by Viktor Zinets on 21.05.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class IOS13TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: collection layout -
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: "kind.header", withReuseIdentifier: "reuse.header")
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
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background")
        return layout
    }
    
    
    
    func sectionFor(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            return section1()
        case 1:
            return section2()
        case 2:
            return section3()
        default:
            fatalError()
        }
    }
        
    func section1() -> NSCollectionLayoutSection {
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                     heightDimension: .fractionalWidth(0.5))
        let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
        leadingItem.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let smallSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallSize)
        smallItem.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
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
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        sectionBackground.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        section.decorationItems = [sectionBackground]
        
        return section
    }
    
    func section3() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(44)) // <----- тут
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(44)) // <----- И тут !!!
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: "kind.header",
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        sectionBackground.contentInsets = .init(top: 50, leading: 8, bottom: 0, trailing: 8)
        section.decorationItems = [sectionBackground]
        
        return section
    }
    
    // MARK: datasource -
    private lazy var dataSource = CollectionDiffAbleDatasource<Int, AnyDiffAble>(collectionView: self.collectionView) { (cell, item) in
    }
    
    func update1() {
        dataSource.beginUpdates()
        dataSource.appendSections([0])
        let item = TestItem(cellReuseId: "TestCell1")
        dataSource.appendItems([AnyDiffAble(item)], toSection: 0)
        dataSource.endUpdates(false)
    }
    
    func update2() {
        dataSource.beginUpdates()
        dataSource.appendSections([0, 1])
        
        let item = TestItem(cellReuseId: "TestCell1")
        let items = [0,1,2,3,4].map{ _ in AnyDiffAble(item) }
        dataSource.appendItems(items, toSection: 0)
        
        let item2 = TestItem(cellReuseId: "TestCell2")
        let items2 = [0,1,2,3,4].map{ _ in AnyDiffAble(item2) }
        dataSource.appendItems(items2, toSection: 1)
        
        dataSource.endUpdates(false)
    }
    
    // MARK: actions -
    @IBAction func action1(_ sender: Any) {
        self.update1()
    }
    
    @IBAction func action2(_ sender: Any) {
        self.update2()
    }
}

struct TestItem: Item {
    var cellReuseId: String
}

private typealias CollectionDataSource = IOS13TestViewController
extension CollectionDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 4
        case 2:
            return 3
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
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            
            return cell
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "kind.header", withReuseIdentifier: "reuse.header", for: indexPath) as! SectionHeader
//        view.label.text = "Section 3"
        return view
    }
    
}

class SectionBackgroundDecorationView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension SectionBackgroundDecorationView {
    func configure() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}

