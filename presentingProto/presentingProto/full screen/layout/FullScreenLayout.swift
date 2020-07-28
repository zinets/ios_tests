//
//  FullScreenLayout.swift
//  mdukProfileProto
//
//  Created by Victor Zinets on 8/7/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

// цель этой раскладки - при обновлении ячеек не делать им автоматическую анимацию фейда/альфы
class FullScreenLayout: UICollectionViewFlowLayout {

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attrs?.alpha = 1
        
        return attrs
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attrs?.alpha = 1
        
        return attrs
    }
}
