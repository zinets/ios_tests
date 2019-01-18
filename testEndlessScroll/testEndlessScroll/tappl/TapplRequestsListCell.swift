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
        if let requestData = data as? TapplRequestsListDatasourceItem {
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
        
        self.setCenterPos(1)
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
    
    func setCenterPos(_ centerPos: CGFloat, animated: Bool = false) {
        let empiricShiftValue = CGFloat(414.0 * 1.74)
        let alpha: CGFloat = 1 - abs(centerPos)
        
        UIView.animate(withDuration: animated ? 0.3 : 0.0, delay: 0.0, options: [.curveEaseOut], animations: {
            self.overlayView.alpha = alpha == 1 ? 1 : 0
            self.overlayView.transform = alpha == 1 ? .identity : CGAffineTransform(scaleX: 0.3, y: 0.3)
            
            self.screennameLabel.alpha = alpha == 1 ? 1 : 0
            self.screennameLabel.transform = CGAffineTransform(translationX: 100 * centerPos, y: 0)
            
            self.heartControl.alpha = alpha > 0.3 ? 1 : 0
            self.heartControl.transform = CGAffineTransform(translationX: empiricShiftValue * centerPos, y: 0)
        }) { (_) in
            
        }
    }
    
//    var centerPos: CGFloat = 1 {
//        didSet {
//            let empiricShiftValue = CGFloat(414.0 * 1.74)
//            let alpha: CGFloat = 1 - abs(centerPos)
//
////            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
//                self.overlayView.alpha = alpha == 1 ? 1 : 0
//                self.overlayView.transform = alpha == 1 ? .identity : CGAffineTransform(scaleX: 0.3, y: 0.3)
//
//                self.screennameLabel.alpha = alpha == 1 ? 1 : 0
//                self.screennameLabel.transform = CGAffineTransform(translationX: 100 * self.centerPos, y: 0)
//
//                self.heartControl.alpha = alpha > 0.3 ? 1 : 0
//                self.heartControl.transform = CGAffineTransform(translationX: empiricShiftValue * self.centerPos, y: 0)
////            }) { (_) in
////
////            }
//        }
//    }
}

