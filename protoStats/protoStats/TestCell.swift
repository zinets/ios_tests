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
    
    @IBOutlet var ghost1: UIView!{
        didSet {
            ghost1.layer.cornerRadius = 22
        }
    }
    @IBOutlet var ghost2: UIView!{
        didSet {
            ghost2.layer.cornerRadius = 22
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
            let duration = 0.6
            
            let a1 = CABasicAnimation(keyPath: "transform.scale")
            a1.duration = duration
            a1.fromValue = 1
            a1.toValue = 1.152
            
            let a2 = CABasicAnimation(keyPath: "opacity")
            a2.duration = duration
            a2.fromValue = 1
            a2.toValue = 0
            
            let group = CAAnimationGroup()
            group.duration = duration
            group.animations = [a1, a2]
            
            self?.ghost1.layer.add(group, forKey: nil)
            
            let group2 = CAAnimationGroup()
            group2.duration = duration
            group2.beginTime = CACurrentMediaTime() + 0.3
            group2.animations = [a1, a2]
            
            self?.ghost2.layer.add(group2, forKey: nil)
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


