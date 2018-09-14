//
//  ViewController.swift
//  testZoom
//
//  Created by Victor Zinets on 9/13/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topC: NSLayoutConstraint!    
    @IBOutlet weak var leftC: NSLayoutConstraint!
    @IBOutlet weak var rightC: NSLayoutConstraint!
    
    @IBOutlet weak var heightC: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollView: ImageZoomView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loadImage(_ sender: Any) {
        let image = UIImage(named: "zoomTest.jpg")
        scrollView.image = image
        scrollView.zoomEnabled = true
        scrollView.contentMode = .scaleAspectFill
    }
    
    @IBAction func resizeZoomer(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.5) {
        
            
            if sender.isSelected {
//                let newFrame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 106)
//                self.scrollView.frame = newFrame
                self.heightC.constant = 600
                self.leftC.constant = 0
                self.rightC.constant = 0
                
                self.view.layoutIfNeeded()
                self.scrollView.contentMode = .scaleAspectFit
            } else {
//                let newFrame = CGRect(x: 16, y: 106, width: self.view.bounds.size.width - 2 * 16, height: self.view.bounds.size.height - 2 * 106)
//                self.scrollView.frame = newFrame
                
                self.heightC.constant = 250
                self.leftC.constant = 40
                self.rightC.constant = 40
                
                
                self.view.layoutIfNeeded()
                self.scrollView.contentMode = .scaleAspectFill
                
            }
            

        }
    }
    
    @IBAction func changeHeight(_ sender: UISlider) {
        heightC.constant = CGFloat(250.0 + 250.0 * sender.value)
//        scrollView.zoomScale = scrollView.minimumZoomScale
        
        let scaleX = scrollView.bounds.size.width / scrollView.image!.size.width
        let scaleY = scrollView.bounds.size.height / scrollView.image!.size.height
        let scaleToFit = min(scaleX, scaleY)
        let scaleToFill = max(scaleX, scaleY)
        print("toFit \(scaleToFit), toFill \(scaleToFill), scale \(scrollView.zoomScale)")
        
        let a = (scaleToFill - scaleToFit) + scrollView.minimumZoomScale
        scrollView.zoomScale = a
        
        
    }
}

