//
//  ViewController.swift
//  animations
//
//  Created by Viktor Zinets on 22.01.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var greenView: UIView! {
        didSet {
            greenView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeCard(sender:))))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipableInFutureView = TestView2(frame: CGRect(x: 50, y: 250, width: 200, height: 100))
        swipableInFutureView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeCard(sender:))))
        self.view.addSubview(swipableInFutureView)
    }
    
    @objc func swipeCard(sender: UIPanGestureRecognizer) {
        sender.swipeView()
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
//        cell.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        return cell
    }
    
    
}

class TestCell: UICollectionViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attrs = layoutAttributes as? CollectionViewProgressLayoutAttributes {
            topLabel.text = String(format: "%f", attrs.progress)
            bottomLabel.text = String(format: "%d", attrs.indexPath.item)
            // ===
//            let angle = .pi * attrs.progress
//            var transform = CATransform3DIdentity;
//            transform.m34 = -0.0015;
//            transform = CATransform3DRotate(transform, angle, 0, 1, 0)
//
//            self.layer.transform = transform
//            self.alpha = abs(attrs.progress) > 0.5 ? 0 : 1
            // ===
//            let transform = CGAffineTransform(translationX: bounds.width * 0.8 * attrs.progress, y: 0)
//            let alpha = 1 - abs(attrs.progress) + 0.2
//            if attrs.indexPath.item == 1 {
//                print(attrs.progress)
//            }
//            contentView.subviews.forEach { $0.transform = transform }
//            contentView.alpha = alpha
            // ===
            
            let angle = attrs.progress * CGFloat.pi / 6
            let transform = CGAffineTransform(rotationAngle: angle)

            self.transform = transform
        }
    }
    
}





