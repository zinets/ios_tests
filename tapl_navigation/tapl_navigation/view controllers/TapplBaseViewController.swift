//
//  TapplViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController: UIViewController {
    
    /// призрак предыдущего контроллера
    var underlayingView: UIView? {
        willSet {
            underlayingView?.removeFromSuperview()
        }
        didSet {
//            let v = UIView(frame: CGRect(x: 0, y: self.view.frame.origin.y, width: 414, height: 20))
//            v.backgroundColor = .magenta
            if underlayingView != nil {
                underlayingView!.frame.origin = CGPoint.zero
                self.view.superview?.insertSubview(underlayingView!, belowSubview: self.view)
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let additionalSpace: CGFloat = 8
        view.frame.origin.y += additionalSpace
        view.frame.size.height -= additionalSpace
    }
    
    // MARK: navigation
    
    @IBAction func navButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1: print("do search")
        case 2: print("do messages")
        case 3: print("do activities")
        case 4: print("do profile")
        default: break;
        }
    }
    
    
    
}
