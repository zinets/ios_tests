//
//  ViewController.swift
//  activitiesProto
//
//  Created by Victor Zinets on 1/16/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    func commonInit() {
        
        segmentedControl.backgroundColor = .white
        segmentedControl.tintColor = .white
        
        segmentedControl.layer.cornerRadius = 1
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor(rgb: 0xededec).cgColor
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.orange
        ], for: .selected)
        
        let image = UIImage().colored(with: UIColor(rgb: 0xededec), size: CGSize(width: 1, height: 1))
        segmentedControl.setDividerImage(image, forLeftSegmentState: UIControl.State.normal, rightSegmentState: UIControl.State.normal, barMetrics: UIBarMetrics.default)
    }
    
}

extension UIImage {
    
    func colored(with color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
