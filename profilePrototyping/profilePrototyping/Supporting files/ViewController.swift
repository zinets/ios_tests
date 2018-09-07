//
//  ViewController.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController/*, IPageControlDatasource*/ {
//    @IBOutlet weak var instaCtrl: IPageControl!
    @IBOutlet weak var labelWow: UILabel!
    
    var instaCtrl2: IPageControl = {
        let ctrl = IPageControl(frame: CGRect(x: 50, y: 50, width: 200, height: 10))
        ctrl.backgroundColor = UIColor.brown
        ctrl.numberOfPages = 10
        return ctrl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let instaCtrl = InstagramPageControl(frame: CGRect(x: 50, y: 100, width: 50, height: 10))
//        instaCtrl.backgroundColor = UIColor.brown
//        view.addSubview(instaCtrl)        
//        instaCtrl.dotSize = 20
//
//        instaCtrl.dataSource = self
//        instaCtrl.displayCount = 6
//        instaCtrl.numberOfPages = 10
//        instaCtrl.currentPage = 0
        
        view.addSubview(instaCtrl2)
        
        labelWow.transform = CGAffineTransform(rotationAngle: 0.4)
    }
    
    @IBAction func decInstaCounter(_ sender: Any) {
        let index = instaCtrl2.currentPage - 1
        instaCtrl2.setCurrentPage(at: index)
    }
    
    @IBAction func addInstaCounter(_ sender: Any) {
        let index = instaCtrl2.currentPage + 1
        instaCtrl2.setCurrentPage(at: index)
    }
    
    @IBAction func showProfile(_ sender: Any) {
        if let ctrl = UIStoryboard.init(name: "Profile", bundle: nil).instantiateInitialViewController() {
            self.show(ctrl, sender: nil)
        }
        
    }
    
    @IBOutlet weak var testView: UIView!
    
    @IBAction func testAnimation(_ sender: UIButton) {
        
    }
    
//    func pageControl(_ sender: IPageControl, viewForIndex: Int) -> IPageControlItem {
//        let item = IPageControlDotItem(sender.dotSize, dotSize: sender.dotSize, newIndex: viewForIndex)
//        return item
//    }
}

