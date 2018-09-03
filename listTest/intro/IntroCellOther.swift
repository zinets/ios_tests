//
//  IntroCellOther.swift
//  listTest
//
//  Created by Victor Zinets on 9/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class IntroCellOther: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func fillData(_ data: DataSourceItem) {
        if let imageName = data.payload as? String {
            imageView.image = UIImage(named: imageName)
        }
    }
}
