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
        
        
    }
    
    @objc func swipeCard(sender: UIPanGestureRecognizer) {
        sender.swipeView(greenView)
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
        if let attrs = layoutAttributes as? CollectionViewPagingLayoutAttributes {
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






protocol Swipeable { }

extension Swipeable where Self: UIPanGestureRecognizer {
    
    func swipeView(_ view: UIView) {
        
        // управление вью
//        switch state {
//        case .changed:
//            let translation = self.translation(in: view.superview)
//            view.transform = transform(view: view, for: translation)
//        case .ended:
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [], animations: {
//                view.transform = .identity
//            }, completion: nil)
//
//        default:
//            break
//        }
        
        // управление слоем
        let panGestureTranslation = self.translation(in: view)
        switch state {
        case .began:
            let initialTouchPoint = self.location(in: view)
            let newAnchorPoint = CGPoint(x: initialTouchPoint.x / view.bounds.width, y: initialTouchPoint.y / view.bounds.height)
            let oldPosition = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
            let newPosition = CGPoint(x: view.bounds.size.width * newAnchorPoint.x, y: view.bounds.size.height * newAnchorPoint.y)
            view.layer.anchorPoint = newAnchorPoint
            view.layer.position = CGPoint(x: view.layer.position.x - oldPosition.x + newPosition.x, y: view.layer.position.y - oldPosition.y + newPosition.y)

            
            view.layer.rasterizationScale = UIScreen.main.scale
            view.layer.shouldRasterize = true
//            delegate?.didBeginSwipe(onView: self)
        case .changed:
            let rotationStrength = min(panGestureTranslation.x / view.frame.width, CGFloat.pi / 4)
            let rotationAngle = CGFloat.pi / 4 * rotationStrength
            print(rotationStrength)
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, panGestureTranslation.y, 0)
            view.layer.transform = transform
        case .ended:
            let rotationStrength = min(panGestureTranslation.x / view.frame.width, CGFloat.pi / 4)
            
            view.layer.shouldRasterize = false
            
            if abs(rotationStrength) > 0.3 {
//              self.delegate?.didEndSwipe(onView: self)
                // тут анимация улетания
            } else {
//              self.delegate?.didCancelSwipe(onView: self)
                view.layer.transform = CATransform3DIdentity
            }
        default:
            break
        }
    }
        
    private func transform(view: UIView, for translation: CGPoint) -> CGAffineTransform {
        
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        // знак определяет "центр" вращения - "-" значит центр сверху, "+" - внизу
        let rotation = -sin(translation.x / (view.frame.width * 4.0))
        return moveBy.rotated(by: rotation)
    }
}

extension UIPanGestureRecognizer: Swipeable { }


