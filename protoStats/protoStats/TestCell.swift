//
//  TestCell.swift
//  protoStats
//
//  Created by Victor Zinets on 21.12.2022.
//

import UIKit

class TestCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPulsation(on: ghost2)
        setupPulsation(on: ghost1, delay: 0.3)
    }
    
    @IBOutlet var label: UILabel!
    @IBOutlet var bgCView: UIView! {
        didSet {
            bgCView.layer.cornerRadius = 22
            bgCView.backgroundColor = UIColor(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        }
    }
    
    @IBOutlet var ghost1: UIView!
    @IBOutlet var ghost2: UIView!
    @IBOutlet var button: UIButton! {
        didSet {
            button.layer.cornerRadius = 22
        }
    }
    
    @IBAction func testPulse(_ sender: Any) {
        let duration = 0.6
        
        let a1 = CABasicAnimation(keyPath: "transform.scale")
        a1.duration = duration
        a1.fromValue = 1
        a1.toValue = 2
        
        let a2 = CABasicAnimation(keyPath: "opacity")
        a2.duration = duration
        a2.fromValue = 1
        a2.toValue = 0
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = [a1, a2]
        
        ghost1.layer.add(group, forKey: nil)
        
        let group2 = CAAnimationGroup()
        group2.duration = duration
        group2.beginTime = CACurrentMediaTime() + 0.3
        group2.animations = [a1, a2]
        
        ghost2.layer.add(group2, forKey: nil)
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


