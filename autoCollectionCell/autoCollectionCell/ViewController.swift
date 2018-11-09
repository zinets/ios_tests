//
//  ViewController.swift
//  autoCollectionCell
//
//  Created by Victor Zinets on 11/8/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let sampleData = [ "чистый White" , "светлый Red", "Black", "бледный Yellow", "грязный Purple" ]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var barabanView: BlindHorizBaraban!
    @IBOutlet weak var testButton: RaisingParticleAnimatedButton!
    
    let testDataSource: TestDataSource = {
        return TestDataSource()
    }()
    @IBOutlet weak var testCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 40)
        }
        
        barabanView.headerText = "fuck u asshole"
        barabanView.items = sampleData
        
        testCollection.dataSource = self.testDataSource
        
        testButton.addTarget(self, action: #selector(select(sender:)), for: UIControl.Event.touchUpInside)
        
        
        testCollection.addSubview(testButton)
        testButton.frame = CGRect(x: 30, y: 350, width: 44, height: 44)
        
    }
   
    @IBAction func select(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
            cell.textLabel.text = sampleData[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    
}


