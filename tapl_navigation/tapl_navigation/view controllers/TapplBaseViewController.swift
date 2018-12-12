//
//  TapplViewController.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/7/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController: UIViewController {
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.prepareView()
        
//        underliedLayer.frame = self.view.bounds
//        self.view.layer.insertSublayer(underliedLayer, at: 0)
    }
    
//    override func loadView() {
//
//        let bundle = Bundle(for: type(of: self))
//        if let nibName = self.nibName {
//            let nib = UINib(nibName: nibName, bundle: bundle)
//            view = nib.instantiate(withOwner: self, options: nil).first as? TapplBaseView
//        } else {
//            view = TapplBaseView(frame: CGRect.zero)
//        }

        
        
        
//        if let nibName = self.nibName {
//
//            view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? TapplBaseView
//            //Bundle(for: type(of: self)).loadNibNamed(nibName, owner: self, options: nil)?.first as? TapplBaseView
//
//        } else {
//            view = TapplBaseView(frame: CGRect.zero)
//        }
////        super.loadView()
////        print("\(view)")
//    }

    
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
