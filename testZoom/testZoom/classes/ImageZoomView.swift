//
//  ImageZoomView.swift
//

import UIKit

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    
    private var imageView = UIImageView()
    var zoomEnabled = false {
        didSet {
            scalesForZooming()
        }
    }
    
    private func commonInit() {
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    var image: UIImage? {
        willSet {
            imageView.removeFromSuperview()
        }
        didSet {
            imageView = UIImageView(image: image)
            self.addSubview(imageView)

            scalesForZooming()
        }
    }
    
    var restorePoint: CGPoint!
    var restoreScale: CGFloat!
    
    
    override var frame: CGRect {
        willSet {
            restorePoint = self.pointToCenter()
            restoreScale = self.scaleToRestore()
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
            self.maximumZoomScale = zoomEnabled ? 1 : minScale
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

    private func scaleToRestore() -> CGFloat {
        var contentScale = self.zoomScale
        if contentScale <= self.minimumZoomScale + CGFloat.ulpOfOne {
            contentScale = 0
        }
        return contentScale
    }
    
    private func maximumContentOffset() -> CGPoint {
        let contentSize = self.contentSize
        let boundSize = self.bounds.size
        return CGPoint(x: contentSize.width - boundSize.width,
                       y: contentSize.height - boundSize.height)
    }
    
    private func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }
    
    private func restoreCenterPoint(to oldCenter: CGPoint, oldScale: CGFloat) {
        self.zoomScale = min(self.maximumZoomScale, max(self.minimumZoomScale, oldScale))
        
        let boundsCenter = self.convert(oldCenter, from: imageView)
        var offset = CGPoint(x: boundsCenter.x - self.bounds.size.width/2.0,
                             y: boundsCenter.y - self.bounds.size.height/2.0)
        let maxOffset = self.maximumContentOffset()
        let minOffset = self.minimumContentOffset()
        offset.x = max(minOffset.x, min(maxOffset.x, offset.x))
        offset.y = max(minOffset.y, min(maxOffset.y, offset.y))
        
        self.contentOffset = offset
    }
}
