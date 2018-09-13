//
//  ImageZoomView.swift
//  testZoom
//
//  Created by Victor Zinets on 9/13/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    
    private var imageView = UIImageView()
    
    private func commonInit() {
        imageView.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        imageView.isUserInteractionEnabled = true
        self.addSubview(imageView)
        
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.frame = CGRect(origin: CGPoint.zero, size: image!.size)
            imageView.contentMode = UIViewContentMode.center
            
            scalesForZooming()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("\(#function)")
    }
    
    
    
    var restorePoint: CGPoint!
    var restoreScale: CGFloat!
    
    override var frame: CGRect {
        willSet {
            restorePoint = self.pointToCenter()
            restoreScale = self.scaleToRestoreAfterRotation()
        }
        didSet {
            self.scalesForZooming()
            self.restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
        }
    }
    
    // MARK: zoooming -
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerViewForZooming()
    }
    
    private func scalesForZooming() {
        if let image = image {
            self.contentSize = image.size
            
            let scaleX = self.bounds.size.width / self.contentSize.width
            let scaleY = self.bounds.size.height / self.contentSize.height
            let minScale = min(scaleX, scaleY)
            
            self.minimumZoomScale = minScale
            self.maximumZoomScale = 1
            self.zoomScale = minScale
            
            centerViewForZooming()
        }
    }
    
    private func centerViewForZooming() {
        let boundsSize = self.bounds.size
        var contentFrame = imageView.frame
        
        if contentFrame.size.width < boundsSize.width {
            contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2
        } else {
            contentFrame.origin.x = 0
        }
        if contentFrame.size.height < boundsSize.height {
            contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2
        } else {
            contentFrame.origin.y = 0
        }
        
        imageView.frame = contentFrame
    }
    
    private func pointToCenter() -> CGPoint {
        let boundsCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        return self.convert(boundsCenter, to: imageView)
    }

    private func scaleToRestoreAfterRotation() -> CGFloat {
        var contentScale = self.zoomScale
        if contentScale <= self.minimumZoomScale + CGFloat.ulpOfOne {
            contentScale = 0
        }
        return contentScale
    }
    
    private func maximumContentOffset() -> CGPoint {
        let contentSize = self.contentSize
        let boundSize = self.bounds.size
        return CGPoint(x: contentSize.width - boundSize.width, y: contentSize.height - boundSize.height)
    }
    
    private func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }
    
    private func restoreCenterPoint(to oldCenter: CGPoint, oldScale: CGFloat) {
        self.zoomScale = min(self.maximumZoomScale, max(self.minimumZoomScale, oldScale))
        
        let boundsCenter = self.convert(oldCenter, from: imageView)
        var offset = CGPoint(x: boundsCenter.x - self.bounds.size.width/2.0, y: boundsCenter.y - self.bounds.size.height/2.0)
        let maxOffset = self.maximumContentOffset()
        let minOffset = self.minimumContentOffset()
        offset.x = max(minOffset.x, min(maxOffset.x, offset.x))
        offset.y = max(minOffset.y, min(maxOffset.y, offset.y))
        
        self.contentOffset = offset
    }
}
