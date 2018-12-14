//
//  TapplViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController: UIViewController {
    
    var additionalSpaceFromTop: CGFloat = 72 // абсолютный топ, не additional! по дизу 72
    var interactiveAnimator: TapplInteractiveAnimator?
        
    /// призрак предыдущего контроллера
    var underlayingView: UIView? {
        willSet {
            underlayingView?.removeFromSuperview()
        }
        didSet {
            if underlayingView != nil {
                self.view.superview?.insertSubview(underlayingView!, belowSubview: self.view)
            }
        }
    }
    /// ручка для таскания контроллера по экрану
    var handleForBackGesture: UIView? {
        if let v = self.view as? TapplBaseView {
            return v.handleView
        }
        return nil
    }
    
    var handleIsVisible: Bool {
        set {
            if let v = self.view as? TapplBaseView {
                v.handleView.isHidden = !newValue
            }
        }
        get {
            if let v = self.view as? TapplBaseView {
                return !v.handleView.isHidden
            }
            return false
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
        
        
        view.frame.origin.y = additionalSpaceFromTop
        view.frame.size.height = UIScreen.main.bounds.size.height - additionalSpaceFromTop
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
