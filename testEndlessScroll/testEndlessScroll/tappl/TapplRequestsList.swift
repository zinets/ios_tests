//
//  TapplRequestsList.swift
//  testEndlessScroll
//
//  Created by Victor Zinets on 1/17/19.
//  Copyright © 2019 Victor Zinets. All rights reserved.
//

import UIKit

class TapplRequestsList: UICollectionView {

    private let cellWidth: CGFloat = 68
    private let cellSpacing: CGFloat = 14
    private let internalDataSource = TapplRequestsListDatasource()
    
    var data: [RequestsListDatasourceItem] {
        set {
            internalDataSource.items = newValue
        }
        get {
            return internalDataSource.items as! [RequestsListDatasourceItem]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        internalDataSource.collectionView = self
        
        self.isScrollEnabled = false
        
        var swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLeftAction(_:)))
        swipeRecognizer.direction = .left
        self.addGestureRecognizer(swipeRecognizer)
        
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRightAction(_:)))
        swipeRecognizer.direction = .right
        self.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc private func swipeToLeftAction(_ sender: UISwipeGestureRecognizer) {
        self.selectedIndex += 1
    }
    @objc private func swipeToRightAction(_ sender: UISwipeGestureRecognizer) {
        self.selectedIndex -= 1
    }
    
    var selectedIndex: Int = 0 {
        
        didSet {
            let maxCount = internalDataSource.items.count - 1
            selectedIndex = max(0, min(selectedIndex, maxCount))
            
            let offset = CGFloat(selectedIndex) * (cellWidth + cellSpacing)
            
            UIView.animate(withDuration: 0.75, delay: 0, options: [.curveEaseOut], animations: {
                self.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            }) { (_) in
                
            }
        }
    }

}

extension TapplRequestsList: /*UICollectionViewDataSource,*/ UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TapplRequestsListCellCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let tappleRequestCell = cell as? TapplRequestsListCell {
            tappleRequestCell.centerPos = self.cellPos(cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
    }
    
    // MARK: - appearance
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sz = CGSize(width: cellWidth, height: collectionView.bounds.size.height)
        return sz
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offset = (collectionView.bounds.size.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
       
    // MARK: - scrolling
    
    private func cellPos(_ cell: UICollectionViewCell) -> CGFloat {
        let halfWidth = self.bounds.size.width / 2
        let quaterWidth = halfWidth / 2
        let x = cell.center.x - self.contentOffset.x
        return (x - halfWidth) / quaterWidth
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        for cell in self.visibleCells {
            if let c = cell as? TapplRequestsListCell {
                c.centerPos = self.cellPos(cell)
            }
        }
        
    }
}
