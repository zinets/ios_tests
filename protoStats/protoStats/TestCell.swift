//
//  TestCell.swift
//  protoStats
//
//  Created by Victor Zinets on 21.12.2022.
//

import UIKit

class TestCell: UICollectionViewCell {
    
    
    override func prepareForReuse() {
        timer?.invalidate()
    }
    
    @IBOutlet var label: UILabel!
    @IBOutlet var bgCView: UIView! {
        didSet {
            bgCView.layer.cornerRadius = 22
            bgCView.backgroundColor = UIColor(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        }
    }
        
    private lazy var maskLayer: CAShapeLayer = {
        let mask = CAShapeLayer()
        mask.frame = CGRect(x: 0, y: 0, width: 246, height: 66)
        
        let path = UIBezierPath(roundedRect: CGRect(x: 11, y: 11, width: 224, height: 44), cornerRadius: 22)
        mask.path = path.cgPath
        
        return mask
    }()
    
    @IBOutlet var ghost1: UIView!{
        didSet {
            ghost1.layer.mask = maskLayer
            
            ghost1.isUserInteractionEnabled = false
        }
    }
    @IBOutlet var button: UIButton! {
        didSet {
            button.layer.cornerRadius = 22
        }
    }
    var timer: Timer?
    @IBAction func testPulse(_ sender: Any) {
        
        let pulseCode = { [weak self] in
            let duration = 1.2

            let a1 = CABasicAnimation(keyPath: "path")
            a1.duration = duration
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 246, height: 66), cornerRadius: 33)
            a1.toValue = path.cgPath
            self?.maskLayer.add(a1, forKey: nil)
            
            let a2 = CABasicAnimation(keyPath: "opacity")
            a2.duration = duration
            a2.fromValue = 1
            a2.toValue = 0
            
            let group = CAAnimationGroup()
            group.duration = duration
            group.animations = [a1, a2]
            
            self?.ghost1.layer.add(group, forKey: nil)
            
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] tmr in
            guard let self = self else {
                tmr.invalidate()
                return
            }
            pulseCode()
        }
    }
    
    private func setupPulsation(on view: UIView, delay: TimeInterval = 0) {
        
//        let animator = UIViewPropertyAnimator(duration: 1.2, curve: .easeOut)
//
//        view.alpha = 1
//        view.transform = .identity
//        view.layer.cornerRadius = view.bounds.height / 2
//
//        let scaleX = (view.bounds.width + 22) / view.bounds.width
//        let scaleY = (view.bounds.height + 22) / view.bounds.height
//        let r: CGFloat = view.bounds.height / 2 * scaleX
//
//        animator.addAnimations {
//            view.transform = .init(scaleX: scaleX, y: scaleY)
//            view.alpha = 0
//            view.layer.cornerRadius = r
//        }
//        animator.addCompletion { _ in
//            self.setupPulsation(on: view, delay: 1)
//        }
//
//        animator.startAnimation(afterDelay: delay)
        
        
    }
}


