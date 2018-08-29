//
//  ViewController.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/27/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: MediaScrollerView!
    @IBOutlet weak var gradientProgress: ProgressWithGradient!
    
    
    var items = [PhotoFromInternetModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls: [String] = [
            "https://www.white-ibiza.com/wp-content/uploads/wellbeing-opener.jpg",
            "https://ae01.alicdn.com/kf/HTB10Nk9eDnI8KJjy0Ffq6AdoVXar/Ceremokiss-Summer-Sexy-Club-Swimwear-Women-Bikini-Sets-Stripes-Bandage-Swimsuit-Push-Up-Bathing-Suit-Brazilian.jpg",
            "https://www.dhresource.com/0x0s/f2-albu-g5-M01-8E-87-rBVaI1k-RhKAXE7jAAaagwlQR_4251.jpg/velvet-bikini-2017-sexy-micro-bikinis-women.jpg",
            "https://www.dhresource.com/albu_226507030_00-1.0x0/halter-dropshipping.jpg",
            "https://thumbs.dreamstime.com/b/bikini-girl-sitting-seaside-rock-15452009.jpg",
            "https://i.pinimg.com/originals/c4/81/e0/c481e0eca617af42933ff5a8c747dc67.jpg",
            "https://www.glifting.co.uk/wp-content/uploads/2017/03/Glifting-Girls-Ibiza-2017-2-1024x683.jpg",
            "https://c1.staticflickr.com/5/4109/5447991626_2121c39120_b.jpg",
        ]
        
        
        
        for url in urls {
            let newItem = PhotoFromInternetModel()
            newItem.url = url
            
            items.append(newItem)
        }
        
        collectionView.autoScroll = false
        collectionView.tapToScroll = true
        collectionView.endlessScrolling = true
        
        
        // gradients
        let gradientLayer1 = CAGradientLayer()
        
        gradientLayer1.colors = [
            UIColor(rgb: 0xfec624).cgColor,
            UIColor(rgb: 0xf161f8).cgColor,
            UIColor(rgb: 0x7b2df8).cgColor
        ]
        gradientLayer1.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer1.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer1.frame = grad1.bounds
        
        grad1.layer.addSublayer(gradientLayer1)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = grad1.bounds.insetBy(dx: 10, dy: 10)
        let path = UIBezierPath(ovalIn: maskLayer.bounds)
                
        maskLayer.path = path.cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.lineWidth = 10
        maskLayer.lineCap = kCALineCapRound
        
        maskLayer.strokeStart = 0.0
        let pos: CGFloat = 0.95
        maskLayer.strokeEnd = pos
        
        
        
        
        let angle: CGFloat = .pi / 2
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DScale(transform, -1, 1, 1)
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        
        maskLayer.transform = transform
        
        grad1.layer.mask = maskLayer
        
        gradientProgress.position = 0.25
    }

    @IBAction func fillCollection(_ sender: Any) {
        collectionView.items = items
    }
    
    @IBAction func aspectCnahge(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            collectionView.contentMode = .scaleAspectFit
            sender.setTitle("aspect fit", for: .normal)
        } else {
            collectionView.contentMode = .scaleAspectFill
            sender.setTitle("aspect fill", for: .normal)
        }
    }
    
    @IBOutlet weak var grad1: UIView!
    
    @IBAction func sliderChanges(_ sender: UISlider) {
        gradientProgress.position = CGFloat(sender.value)
    }
    
}

