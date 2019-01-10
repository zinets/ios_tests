//
//  ViewController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 12/27/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

extension CGFloat {
    func inRads() -> CGFloat {
        return self * .pi / 180.0
    }
}

extension Int {
    func inRads() -> CGFloat {
        return CGFloat(self) * .pi / 180.0
    }
}



class ViewController: UIViewController {

    @IBOutlet weak var infiniteScroller: TapplAnimatedOnboardingBgView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
   
    @IBAction func startAnimation(_ sender: Any) {
        infiniteScroller.startAnimation()
    }
    
    @IBAction func stopAnim(_ sender: Any) {
        infiniteScroller.stopAnimation()
    }
}

