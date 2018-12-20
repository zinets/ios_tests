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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 40
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.2
        self.view.layer.shadowColor = UIColor.black.cgColor
        
    }


    @IBAction func openNew(_ sender: Any) {
        guard let ctrl = storyboard?.instantiateInitialViewController() else {
            fatalError("Could not instantiate controller from Storyboard")
        }
        
        ctrl.transitioningDelegate = ctrlTransitioningDelegate
        ctrl.modalPresentationStyle = .custom
        present(ctrl, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
