//
//  ViewController.swift
//  skeleton
//
//  Created by Viktor Zinets on 25.05.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class SkeletonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beginSkeletAnimation(for: view)
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    func beginSkeletAnimation(for view: UIView) {
        let gradient = self.makeGradient(view: view)
        gradient.add(self.makeLocationsAnimaton(), forKey: nil)
        self.view.layer.addSublayer(gradient)
    }
    
    
    func makeSkelet(for view: UIView) -> CALayer {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.fillColor = UIColor.clear.cgColor
       
        view.subviews.forEach { (view) in
            let subPath: UIBezierPath
            switch view {
            case is UILabel:
                subPath = UIBezierPath(roundedRect: view.frame, cornerRadius: 7)
            case is UIButton:
                subPath = UIBezierPath(roundedRect: view.frame, cornerRadius: view.frame.height / 2)
            case is UIImageView:
                subPath = UIBezierPath(roundedRect: view.frame, cornerRadius: view.frame.height / 2)
            default:
                subPath = UIBezierPath(roundedRect: view.frame, cornerRadius: 16)
            }
            let layer = CAShapeLayer()
            layer.path = subPath.cgPath
            maskLayer.addSublayer(layer)
        }
        
        return maskLayer
    }
    
    func makeGradient(view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = .init(x: -0.25, y: 0)
        gradientLayer.endPoint = .init(x: 1.25, y: 1)
        gradientLayer.locations = [-0.25,-0.125, 0]
        
        gradientLayer.frame = view.bounds
//        gradientLayer.mask = self.makeSkelet(for: view)
        
        return gradientLayer
    }
    
    func makeColorsAnimaton() -> CABasicAnimation {
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.duration = 5
        gradientAnimation.fromValue = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientAnimation.toValue = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientAnimation.autoreverses = false
        gradientAnimation.repeatCount = Float.infinity
        gradientAnimation.timingFunction = .init(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        return gradientAnimation
    }
    
    func makeLocationsAnimaton() -> CABasicAnimation {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.duration = 5
        gradientAnimation.fromValue = [-0.25, -0.125, 0]
        gradientAnimation.toValue = [1, 1.125, 1.25]
        gradientAnimation.autoreverses = false
        gradientAnimation.repeatCount = Float.infinity
        
        return gradientAnimation
    }

}

