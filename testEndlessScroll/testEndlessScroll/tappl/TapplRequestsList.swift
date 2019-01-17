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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        self.delegate = self
        
        self.isScrollEnabled = false
        
        var swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLeftAction(_:)))
        swipeRecognizer.direction = .left
        self.addGestureRecognizer(swipeRecognizer)
        
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRightAction(_:)))
        swipeRecognizer.direction = .right
        self.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc private func swipeToLeftAction(_ sender: UISwipeGestureRecognizer) {
        self.scrollOneUser(true)
    }
    @objc private func swipeToRightAction(_ sender: UISwipeGestureRecognizer) {
        self.scrollOneUser(false)
    }
    private func scrollOneUser(_ toLeft: Bool) {
        var pt = self.contentOffset
        self.setContentOffset(CGPoint(x: pt.x + (cellWidth + cellSpacing) * (toLeft ? 1 : -1), y: 0), animated: true)
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            
        }
    }

}

extension TapplRequestsList: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
