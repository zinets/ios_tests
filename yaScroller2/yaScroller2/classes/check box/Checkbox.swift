//
//  Checkbox.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class Checkbox: UIButton {

    private func commonInit() {        
        setImage(#imageLiteral(resourceName: "checked"), for: .selected)
        setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        
        self.imageView?.contentMode = .center
        self.imageView?.backgroundColor = UIColor.yellow
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.backgroundColor = UIColor.magenta
        
        layer.borderWidth = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    let spaceAroundImage: CGFloat = 9
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        if let image = self.image(for: self.state) {
            let sz = CGSize(width: image.size.width + 2 * spaceAroundImage,
                            height: image.size.height + 2 * spaceAroundImage)
            return CGRect(origin: CGPoint.zero, size: sz)
        }
        
        return super.imageRect(forContentRect: contentRect)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        if let text = title(for: self.state) {
            let imageRect = self.imageRect(forContentRect: bounds)
            let textWidth = bounds.size.width - imageRect.size.width
            let font = UIFont.systemFont(ofSize: 18)
            let textHeight = text.sizeWithConstrainedWidth(width: textWidth, font: font).height
            return CGRect(x: imageRect.size.width,
                          y: 0,
                          width: textWidth,
                          height: textHeight)
        }
        return super.titleRect(forContentRect: contentRect)
    }
    
    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        let imageRect = self.imageRect(forContentRect: bounds)
        let titleRect = self.titleRect(forContentRect: bounds)

        let rect = CGRect(x: 0, y: 0,
                      width: imageRect.size.width + titleRect.size.width,
                      height: max(imageRect.size.height, titleRect.size.height))
        return rect
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return contentRect(forBounds: self.bounds).size
        }
    }
}
