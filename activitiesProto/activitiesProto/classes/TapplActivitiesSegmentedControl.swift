//
//  TapplActivitiesSegmentedControl.swift
//  activitiesProto
//
//  Created by Victor Zinets on 1/16/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class TapplActivitiesSegmentedControl: UISegmentedControl {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.commonInit()
//    }
//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private let borderColor = UIColor(rgb: 0xededec)
    private let inactiveTextColor = UIColor(rgb: 0x999999)
    private let activeTextColor = UIColor.black
    private let textFont = UIFont.systemFont(ofSize: 13, weight: .bold)
    
    private func commonInit() {
        self.backgroundColor = .clear
        self.tintColor = .clear
        
        self.layer.cornerRadius = 1
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        
        let labelAttributes = [
            NSAttributedString.Key.foregroundColor: inactiveTextColor,
            NSAttributedString.Key.font: textFont
        ]
        self.setTitleTextAttributes(labelAttributes, for: .normal)
        
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: activeTextColor,
            NSAttributedString.Key.font: textFont
        ], for: .selected)
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(borderColor.cgColor)
            context.fill(rect);
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                self.setDividerImage(image, forLeftSegmentState: UIControl.State.normal, rightSegmentState: UIControl.State.normal, barMetrics: UIBarMetrics.default)
            }
            
            UIGraphicsEndImageContext();
        }
        
//        let activityIndicatorColor = UIColor(rgb: 0xfc471e)
//        let segmentWidth = self.bounds.size.width / CGFloat(self.numberOfSegments)
//        for i in 0..<self.numberOfSegments {
//            if let string = self.titleForSegment(at: i) {
//                let segmentFrame = CGRect(x: CGFloat(i) * segmentWidth, y: 0, width: segmentWidth, height: self.bounds.size.height)
//                let attributedString = NSAttributedString(string: string, attributes: labelAttributes)
//                let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
//
//                let sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, segmentFrame.size, nil)
//                let x = segmentFrame.origin.x + (segmentWidth - sz.width) / 2 + sz.width
//                let indicatorFrame = CGRect(origin: CGPoint(x: x, y: 5), size: CGSize(width: 6, height: 6))
//
//                let indicatorView = UIView(frame: indicatorFrame)
//                indicatorView.backgroundColor = activityIndicatorColor
//
//                self.addSubview(indicatorView)
//            }
//        }
    }

    private var segmentActiveLabels: [Int: UIView] = [:]
    func setSegmentActivityIndicator(_ index: Int, newValue: Bool) {
        if newValue { // показать точку
            if segmentActiveLabels[index] == nil, let string = self.titleForSegment(at: index) {
                let activityIndicatorColor = UIColor(rgb: 0xfc471e)
                let segmentWidth = self.bounds.size.width / CGFloat(self.numberOfSegments)
                
                let segmentFrame = CGRect(x: CGFloat(index) * segmentWidth, y: 0, width: segmentWidth, height: self.bounds.size.height)
                let attributedString = NSAttributedString(string: string,
                                                          attributes: self.titleTextAttributes(for: .normal))
                let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
                
                let sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: 0), nil, segmentFrame.size, nil)
                let x = segmentFrame.origin.x + (segmentWidth - sz.width) / 2 + sz.width
                let cornerRadius: CGFloat = 6
                let indicatorFrame = CGRect(origin: CGPoint(x: x, y: 5), size: CGSize(width: cornerRadius, height: cornerRadius))
                
                let indicatorView = UIView(frame: indicatorFrame)
                indicatorView.layer.cornerRadius = cornerRadius / 2
                indicatorView.backgroundColor = activityIndicatorColor
                self.addSubview(indicatorView)
                
                indicatorView.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 0.3, animations: {
                    indicatorView.transform = .identity
                }) { (_) in
                    self.segmentActiveLabels[index] = indicatorView
                }
            }
        } else { // убрать точку
            if let view = segmentActiveLabels[index] {
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = CGAffineTransform(scaleX: 0, y: 0)
                }) { (_) in
                    view.removeFromSuperview()
                    self.segmentActiveLabels[index] = nil
                }
            }
        }
    }
}
