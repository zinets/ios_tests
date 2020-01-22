//
//  ViewController.swift
//  animations
//
//  Created by Viktor Zinets on 22.01.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = CollectionViewPagingLayout()
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        return cell
    }
    
    
}

class TestCell: UICollectionViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attrs = layoutAttributes as? CollectionViewPagingLayoutAttributes {
            topLabel.text = String(format: "%f", attrs.progress)
            bottomLabel.text = String(format: "%d", attrs.indexPath.item)
        }
    }
    
}
