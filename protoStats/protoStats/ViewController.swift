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
        
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, offset, _ in
            
            guard let self = self else { return }
            let center = CGPoint(x: self.collectionView.bounds.width / 2 + offset.x,
                                 y: self.collectionView.bounds.height / 2)
            let item = visibleItems.filter { $0.frame.contains(center) }.first
            self.itemToScroll = item?.indexPath.item ?? 0
                        
            self.restartTimer()
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private var scrollTimer: Timer?
    private var itemToScroll: Int = 0
    private func restartTimer() {
        scrollTimer?.invalidate()
        
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block: { [weak self] tmr in
            guard let self = self else {
                tmr.invalidate()
                return
            }
            
            self.itemToScroll = (self.itemToScroll + 1) % self.datasource.count
            let index = IndexPath(item: self.itemToScroll, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        })
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

