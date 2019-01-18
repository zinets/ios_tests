//
//  TapplRequestsListCellCollectionViewCell.swift
//  testEndlessScroll
//
//  Created by Victor Zinets on 1/17/19.
//  Copyright © 2019 Victor Zinets. All rights reserved.
//

import UIKit
import CollectionControls

class TapplRequestsListCell: UICollectionViewCell, DataAwareCell {
    
    func fillWithData(_ data: DataSourceItem) {
        if let requestData = data as? RequestsListDatasourceItem {
            screennameLabel.text = requestData.screenName
            avatarView.image = UIImage(named: requestData.imageName)
            heartControl.image = UIImage(named: requestData.heartName)
        }
        
    }
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var heartControl: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        screennameLabel.alpha = 0
        overlayView.alpha = 0
    }
    
    // MARK: - appearance
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.layer.cornerRadius = avatarView.bounds.size.width / 2
        avatarView.layer.masksToBounds = true
        
        overlayView.layer.cornerRadius = overlayView.bounds.size.width / 2
        overlayView.layer.borderWidth = 2
        overlayView.layer.borderColor = UIColor.red.cgColor
        
    }
    
    var centerPos: CGFloat = 0 {
        didSet {
            let empiricShiftValue = CGFloat(414.0 * 1.74)
            heartControl.transform = CGAffineTransform(translationX: empiricShiftValue * centerPos, y: 0)
            
            let alpha: CGFloat = (1 - abs(centerPos)) == 1 ? 1 : 0
            UIView.animate(withDuration: 0.5) {
                self.overlayView.alpha = alpha
                self.overlayView.transform = alpha == 1 ? .identity : CGAffineTransform(scaleX: 0.3, y: 0.3)
                
                self.screennameLabel.alpha = alpha
                self.screennameLabel.transform = CGAffineTransform(translationX: 100 * self.centerPos, y: 0)
                
            }
        }
    }
}

