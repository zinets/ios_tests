//
//  TapplBlurredImageView.swift
//  unblurTest
//
//  Created by Victor Zinets on 1/11/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class TapplBlurredView: UIView {
 
    private var blurredImageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        
        blurredImageView = UIImageView(frame: self.bounds)
        blurredImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurredImageView)
    }
    
    func update() {
        // тут надо взять картинку "снизу", заблурить и положить в имажВью для стирания
        guard let superView = self.superview else {
            return
        }
        
        // фукц - если делать обновления, то видно будет моргания, но т.к. нормальное использование подразумевает, что сначала у нас ничего нет, потом апдейтим и все - то моргания юзер не увидит
        // но оно есть
        self.blurredImageView.isHidden = true
        
        let renderer = UIGraphicsImageRenderer(bounds: self.frame)
        let image = renderer.image { (ctx) in
            superView.drawHierarchy(in: superView.bounds, afterScreenUpdates: true)
        }
        blurredImageView.image = image.resize4()?.applyBlur(1)
        
        self.blurredImageView.isHidden = false
    }
    
    // MARK: - touches
    
    var lastPoint = CGPoint.zero
    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        blurredImageView.image?.draw(in: self.bounds)
        
        ctx.move(to: fromPoint)
        ctx.addLine(to: toPoint)
        ctx.setLineCap(.round)
        ctx.setBlendMode(.clear)
        ctx.setLineWidth(50)
        
        ctx.setStrokeColor(UIColor.clear.cgColor)
        ctx.strokePath()
        blurredImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        lastPoint = touch.location(in: self)
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



/// это бесполезный (как оказаолось) класс, чтобы загрузить заблуреные сиськи сальмы хайек и протереть картинку от блура.. вдруг когда-нибудь понадобится
final class TapplBlurredImageView: UIView {

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
        self.addSubview(imageView)
        
        blurredImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredImageView.frame = self.bounds
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
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        blurredImageView.image?.draw(in: self.bounds)
        
        ctx.move(to: fromPoint)
        ctx.addLine(to: toPoint)
        ctx.setLineCap(.round)
        ctx.setBlendMode(.clear)
        ctx.setLineWidth(50)
        
        ctx.setStrokeColor(UIColor.clear.cgColor)
        
        // была идея, что если будет пнг с прозрачным размытием, то и рисоваться тач будет с размытым краем - хервам
//        let image = UIImage(named: "brush")
//        let color = UIColor(patternImage: image!)
//        ctx.setStrokeColor(color.cgColor)
        
        ctx.strokePath()
        
        // так тоже не работает, причем от слова "совсем"
//        let maskImage = UIImage(named: "brush")
//        maskImage?.draw(at: fromPoint)
        
        
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
