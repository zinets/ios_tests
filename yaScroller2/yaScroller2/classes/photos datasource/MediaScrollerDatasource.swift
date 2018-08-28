//
//  PhotosDatasource.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class MediaScrollerDatasource : CollectionSectionDatasource {
    
    let sectionCellId = "PhotoFromInternetCell"
    
    // MARK: overrides -
    
    override var collectionView: UICollectionView? {
        didSet {
            if let collection = collectionView {
                collection.register(UINib(nibName: sectionCellId, bundle: nil), forCellWithReuseIdentifier: sectionCellId)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if items[indexPath.item] is PhotoFromInternetModel {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCellId, for: indexPath) as? PhotoFromInternetCell {
                cell.data = items[indexPath.item] as? PhotoFromInternetModel
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            return UICollectionViewCell()
        }
    }
    
    // MARK: endless scrolling -
    
    // бесконечная прокрутка реализована как перестановка элементов первого -> последний и наоборот + отключение "автоанимации"
    // но инициатором должен быть кто-то, кто будет следить за прокруткой или просто по таймеру говорить "дальше!"
    
    func shiftDataPrev()  {
        var data = items
        if let firstObject = data.first {
            data.removeFirst()
            data.append(firstObject)
            
            UIView.setAnimationsEnabled(false)
            items = data
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func shiftDataNext() {
        var data = items
        if let lastObject = data.last {
            data.removeLast()
            data.insert(lastObject, at: 0)
            
            UIView.setAnimationsEnabled(false)
            items = data
            UIView.setAnimationsEnabled(true)
        }
    }   


}
