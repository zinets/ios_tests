//
//  TapplViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController: UIViewController {
    
    private let additionalSpaceFromTop: CGFloat = 8
    
    /// призрак предыдущего контроллера
    var underlayingView: UIView? {
        willSet {
            underlayingView?.removeFromSuperview()
        }
        didSet {
            if underlayingView != nil {
//                underlayingView!.frame.origin.y += 64 + additionalSpaceFromTop
                self.view.superview?.insertSubview(underlayingView!, belowSubview: self.view)
            }
        }
    }
    
    var underlayingViewImage: UIImage? {
        if let view = self.view as? TapplBaseView {
            return view.underlayingViewImage
        }
        return nil
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
        
        
        view.frame.origin.y += additionalSpaceFromTop
        view.frame.size.height -= additionalSpaceFromTop
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
