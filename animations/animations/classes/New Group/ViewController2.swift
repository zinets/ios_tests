//
//  ViewController2.swift
//  animations
//
//  Created by Viktor Zinets on 20.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: outlets -
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
//            collectionView.collectionViewLayout = CollectionViewProgressiveLayout()
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var collectionView2: UICollectionView! {
        didSet {
            collectionView2.dataSource = self
            collectionView2.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
