//
//  ViewController2.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: outlets -
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBAction func scrollLeft(_ sender: Any) {
        guard let layout = self.collectionView.collectionViewLayout as? CollectionViewProgressiveLayout else {
            return
        }
        layout.setCurrentPage(layout.currentPage - 1, animated: true)
        guard let layout2 = self.collectionView2.collectionViewLayout as? CollectionViewStackLayout else {
            return
        }
//        layout2.setCurrentPage(layout2.currentPage - 1, animated: true)
    }
    
    @IBAction func scrollRight(_ sender: Any) {
        guard let layout = self.collectionView.collectionViewLayout as? CollectionViewProgressiveLayout else {
            return
        }
        layout.setCurrentPage(layout.currentPage + 1, animated: true)
        
        guard let layout2 = self.collectionView2.collectionViewLayout as? CollectionViewStackLayout else {
            return
        }
//        layout2.setCurrentPage(layout2.currentPage + 1, animated: true)
    }
    
    
    
    
    @IBOutlet weak var collectionView2: UICollectionView! {
        didSet {
            collectionView2.delegate = self
        }
    }
    enum Sections { case first }
    private lazy var dataSource: CollectionDiffAbleDatasource<Sections, DatasourceItem> = {
        let ds = CollectionDiffAbleDatasource<Sections, DatasourceItem>(collectionView: self.collectionView2) { [weak self] (cell, item) in
            if let cell = cell as? DiffAbleCell {
                cell.configure(item)
            }
        }
        return ds
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dataSource.beginUpdates()
        self.dataSource.appendSections([.first])
        let items = [
            DatasourceItem(data: "cell 0"),
            DatasourceItem(data: "cell 1"),
            DatasourceItem(data: "cell 2"),
            DatasourceItem(data: "cell 3"),
            DatasourceItem(data: "cell 4"),
        ]
        self.dataSource.appendItems(items, toSection: .first)
        self.dataSource.endUpdates(false)
    }
    
    
    
    
    
    
}

extension ViewController2: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressiveCell1", for: indexPath)
        
        return cell
    }
    
    
}

extension ViewController2: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
