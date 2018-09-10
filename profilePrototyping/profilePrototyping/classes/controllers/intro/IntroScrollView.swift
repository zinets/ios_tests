//
//  IntroScrollView.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/10/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class IntroScrollView: CollectionBasedScrollerView {
    override open func datasourceForCollection() -> CollectionSectionDatasource {
        return IntrosDatasource()
    }
    
    override open func layoutForCollection() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        
        return layout
    }
    
}

// у интро-вью может быть 2 варианта ячеек
private class IntrosDatasource: CollectionSectionDatasource {
    override var supportedCellTypes: [CellType] {
        return ["IntroPage0", "IntroPageX"]
    }
    
    override func cellNibFor(_ cellType: CellType) -> String? {
        switch cellType {
        case "IntroPage0":
            return "IntroPage0Cell"
        case "IntroPageX":
            return "IntroPageXCell"
        default:
            return super.cellNibFor(cellType)
        }
    }
}
