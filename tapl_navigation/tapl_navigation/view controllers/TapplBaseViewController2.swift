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
