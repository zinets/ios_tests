//
//  TestDataSource.swift
//  autoCollectionCell
//
//  Created by Victor Zinets on 11/9/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TestDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
    }
    
    
    
}
