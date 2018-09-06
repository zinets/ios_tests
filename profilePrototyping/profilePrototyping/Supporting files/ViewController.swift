//
//  ViewController.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IPageControlDatasource {
    @IBOutlet weak var instaCtrl: IPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let instaCtrl = InstagramPageControl(frame: CGRect(x: 50, y: 100, width: 50, height: 10))
//        instaCtrl.backgroundColor = UIColor.brown
//        view.addSubview(instaCtrl)
        instaCtrl.dataSource = self
        instaCtrl.displayCount = 5
        instaCtrl.numberOfPages = 5
        instaCtrl.currentPage = 0
    }
    
    @IBAction func decInstaCounter(_ sender: Any) {
        let index = instaCtrl.currentPage - 1
        instaCtrl.currentPage = index
    }
    
    @IBAction func addInstaCounter(_ sender: Any) {
        let index = instaCtrl.currentPage + 1
        instaCtrl.currentPage = index
    }    
    
    @IBAction func showProfile(_ sender: Any) {
        if let ctrl = UIStoryboard.init(name: "Profile", bundle: nil).instantiateInitialViewController() {
            self.show(ctrl, sender: nil)
        }
        
    }
    
    @IBOutlet weak var testView: UIView!
    
    @IBAction func testAnimation(_ sender: UIButton) {
        
    }
    
    func pageControl(_ sender: IPageControl, viewForIndex: Int) -> IPageControlItem {
        let item = IPageControlDotItem(8, dotSize: 6, newIndex: viewForIndex)
        return item
    }
}

