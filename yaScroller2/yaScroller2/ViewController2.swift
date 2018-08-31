//
//  ViewController2.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var activityIndicator: ThreeDotsActivityIndicator!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var pageControl: PageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        activityIndicator.dotSize = CGSize(width: 10, height: 10)
//        activityIndicator.dotSpace = 10
//        activityIndicator.dotsCount = 5
//        activityIndicator.dotColor = UIColor.blue
//        activityIndicator.activeDotColor = UIColor.red
//        activityIndicator.animationDuration = 3
        
        let activity2 = ThreeDotsActivityIndicator()
        activity2.center = CGPoint(x: stopButton.bounds.size.width / 2 - 30, y: stopButton.bounds.size.height / 2)
        activity2.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        stopButton.addSubview(activity2)
        activity2.startAnimation()
        
        pageControl.numberOfPages = 5
        pageControl.activeDotColor = UIColor(rgb: 0x19b136)
        pageControl.dotColor = pageControl.activeDotColor.withAlphaComponent(0.5)
    }

    @IBAction func startAction(_ sender: Any) {
        activityIndicator.startAnimation()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        activityIndicator.stopAnimation()
    }
    
    @IBAction func checkBoxChanged(_ sender: Checkbox) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func changePage(_ sender: UIButton) {
        if sender.tag == 1 {
            pageControl.pageIndex += 1
        } else if sender.tag == 2 {
            pageControl.pageIndex -= 1
        }
    }
}
