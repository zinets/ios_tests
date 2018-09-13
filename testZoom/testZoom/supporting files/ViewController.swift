//
//  ViewController.swift
//  testZoom
//
//  Created by Victor Zinets on 9/13/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: ImageZoomView!
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.frame = CGRect(x: 16, y: 106, width: self.view.bounds.size.width - 2 * 16, height: self.view.bounds.size.height - 2 * 106)
    }

    @IBAction func loadImage(_ sender: Any) {
        let image = UIImage(named: "zoomTest.jpg")
        scrollView.image = image
    }
    
    @IBAction func resizeZoomer(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.5) {
        
            
            if sender.isSelected {
                let newFrame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 106)
                self.scrollView.frame = newFrame
            } else {
                let newFrame = CGRect(x: 16, y: 106, width: self.view.bounds.size.width - 2 * 16, height: self.view.bounds.size.height - 2 * 106)
                self.scrollView.frame = newFrame
            }
            
        }
    }
    
}

