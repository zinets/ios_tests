//
//  SmallPhotosScroller.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

/// конкретный скроллер конкретных вещей - фотографий юзера
class SmallPhotosScroller: CollectionBasedScrollerView {
    
    override open func commonInit() {
        super.commonInit()
        
        self.paginating = true
        self.oneElementPaginating = false
    }
    
    override open func datasourceForCollection() -> CollectionSectionDatasource {
        return SmallPhotosDatasource()
    }
    
    override open func layoutForCollection() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 8
        
        return layout
    }
    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wideCell = collectionView.numberOfItems(inSection: 0) > 2
        let cellWidth: CGFloat = wideCell ? 130 : 267
        return CGSize(width: cellWidth, height: collectionView.bounds.size.height)
    }
    
    override open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // do nothing
    }
    
    override open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            var targetOffset = targetContentOffset.pointee
            let proposedOffset = targetOffset.x
            let cellSize = self.collectionView(scrollView as! UICollectionView, layout: layout, sizeForItemAt:IndexPath(item: 0, section: 0))
            let pageWidth = cellSize.width + layout.minimumInteritemSpacing
            var newOffset: CGFloat = 0
            if scrollView.contentOffset.x + scrollView.bounds.size.width > scrollView.contentSize.width - layout.sectionInset.right {
                newOffset = scrollView.contentSize.width - scrollView.bounds.size.width
            } else {
                let pageIndex = Int((proposedOffset + pageWidth / 2) / pageWidth)
                newOffset = pageWidth * CGFloat(pageIndex)
            }
            
            targetOffset.x = newOffset
            targetContentOffset.pointee = targetOffset
        }
    }
}

private class SmallPhotosDatasource: CollectionSectionDatasource {
    
    override var supportedCellTypes: [CellType] {
        return ["PortraitProfilePhotoItem"]
    }
    
    override func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case "PortraitProfilePhotoItem":
            return "SmallPhotoScrollerCell"
        default:
            return super.cellNibFor(cellType)
        }
    }
}
