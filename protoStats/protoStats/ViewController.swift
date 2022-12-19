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

class TestCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPulsation(on: ghost2)
        setupPulsation(on: ghost1, delay: 0.3)
    }
    
    @IBOutlet var label: UILabel!
    @IBOutlet var bgCView: UIView! {
        didSet {
            bgCView.layer.cornerRadius = 22
            bgCView.backgroundColor = UIColor(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        }
    }
    
    @IBOutlet var ghost1: UIView!
    @IBOutlet var ghost2: UIView!
    @IBOutlet var button: UIButton! {
        didSet {
            button.layer.cornerRadius = 22
        }
    }
    
    private func setupPulsation(on view: UIView, delay: TimeInterval = 0) {
        
        let animator = UIViewPropertyAnimator(duration: 1.2, curve: .easeOut)
        
        view.alpha = 1
        view.transform = .identity
        view.layer.cornerRadius = view.bounds.height / 2
        
        let scaleX = (view.bounds.width + 22) / view.bounds.width
        let scaleY = (view.bounds.height + 22) / view.bounds.height
        let r: CGFloat = view.bounds.height / 2 * scaleX
        
        animator.addAnimations {
            view.transform = .init(scaleX: scaleX, y: scaleY)
            view.alpha = 0
            view.layer.cornerRadius = r
        }
        animator.addCompletion { _ in
            self.setupPulsation(on: view, delay: 1)
        }
        
        animator.startAnimation(afterDelay: delay)
    }
}

