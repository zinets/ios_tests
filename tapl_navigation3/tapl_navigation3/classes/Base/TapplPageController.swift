//
//  TapplPageController.swift
//  tapl_navigation3
//
//  Created by Victor Zinets on 1/4/19.
//  Copyright © 2019 TN. All rights reserved.
//

import UIKit

class TapplPageController: UIPageViewController {

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newController("TapplSearch"),                
                self.newController("TapplMessages")]
    }()
    
    private func newController(_ id: String) -> UIViewController {
        let ctrl = UIStoryboard(name: id, bundle: nil).instantiateInitialViewController()
        return ctrl!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        if let ctrl = orderedViewControllers.first {
            setViewControllers([ctrl], direction: .forward, animated: true, completion: nil)
        }
    }
    


}

extension TapplPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let ctrlIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
      
        let previousIndex = ctrlIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let ctrlIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = ctrlIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}

