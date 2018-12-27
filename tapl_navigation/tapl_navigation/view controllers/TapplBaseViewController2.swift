//
//  TapplBaseViewController2.swift
//  tapl_navigation
//
//  Created by Victor Zinets on 12/20/18.
//  Copyright © 2018 TN. All rights reserved.
//

import UIKit

class TapplBaseViewController2: UIViewController {

    let ctrlTransitioningDelegate = TapplPresentationDelegate()
    
    @IBOutlet weak var titleLabel: UILabel!
    var shadowIsVisible: Bool = false {
        didSet {
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
                if self.shadowIsVisible {
                    self.view.layer.shadowOpacity = 0.6
                } else {
                    self.view.layer.shadowOpacity = 0.0
                }
            self.view.layer.add(animation, forKey: "shadow")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 40
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.0
        self.view.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.view.layer.shadowColor = UIColor.red.cgColor
        
//        self.shadowIsVisible = true
        
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        titleLabel.text = dateFormatter.string(from: nowDate)
        
        
    }

    @IBAction func switchShadow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        self.shadowIsVisible = sender.isSelected
    }
    
    @IBAction func openNew(_ sender: Any) {
//        guard let ctrl = storyboard?.instantiateInitialViewController() as? TapplBaseViewController2 else {
//            fatalError("Could not instantiate controller from Storyboard")
//        }
        guard let ctrl = storyboard?.instantiateViewController(withIdentifier: "BrownID") as? TapplBaseViewController2 else {
              fatalError("Could not instantiate controller from Storyboard")
        }
        
        ctrl.transitioningDelegate = ctrlTransitioningDelegate
        ctrl.modalPresentationStyle = .custom
        
        present(ctrl, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
}
