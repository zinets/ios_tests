//
//  TapplBlurredImageView.swift
//  unblurTest
//
//  Created by Victor Zinets on 1/11/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class TapplBlurredImageView: UIView {

    private let imageView = UIImageView()
    private let blurredImageView = UIImageView()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            
            // пц как медленно в симулякре
//            if let _ = image, let filter = CIFilter(name: "CIGaussianBlur") {
//                let context = CIContext(options: nil)
//                let beginImage = CIImage(image: image!)
//                filter.setValue(beginImage, forKey: kCIInputImageKey)
//                filter.setValue(30, forKey: kCIInputRadiusKey)
//
//                let output = filter.outputImage
//                let cgimg = context.createCGImage(output!, from: output!.extent)
//                blurredImageView.image = UIImage(cgImage: cgimg!)
//            }
            
            
            
            // все равно медленно
//            blurredImageView.image = image?.blurryImage(blurRadius: 10)
            
            
            // старый-добрый
            if let _ = image {
                blurredImageView.image = image!.resize4()?.applyBlur(10)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.frame = self.bounds
//        imageView.image = UIImage(named: "salma.jpg")
        self.addSubview(imageView)
        
        blurredImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredImageView.frame = self.bounds
//        blurredImageView.image = UIImage(named: "moloko.jpg")
        self.addSubview(blurredImageView)
    }
    
    // MARK: - touches
    
    var lastPoint = CGPoint.zero
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        lastPoint = touch.location(in: self)
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        blurredImageView.image?.draw(in: self.bounds)
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.setLineCap(.round)
        context.setBlendMode(.clear)
        context.setLineWidth(50)
        context.setStrokeColor(UIColor.clear.cgColor)
        context.strokePath()
        blurredImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let currentPoint = touch.location(in: self)
        drawLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawLine(from: lastPoint, to: lastPoint)
    }
}
