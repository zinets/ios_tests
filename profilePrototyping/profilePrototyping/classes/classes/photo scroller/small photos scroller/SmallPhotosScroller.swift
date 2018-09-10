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
        
        self.paginating = false
        self.oneElementPaginating = false
    }
    
    override open func datasourceForCollection() -> CollectionSectionDatasource {
        return SmallPhotosDatasource()
    }
    
    override open func layoutForCollection() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 10
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.numberOfItems(inSection: 0) > 2 ? 130 : 270;
        return CGSize(width: cellWidth, height: self.bounds.size.height)
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
