//
//  ViewController.swift
//  yaScroller2
//
//  Created by Victor Zinets on 8/27/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: MediaScrollerView!
    
    var items = [PhotoFromInternetModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls: [String] = [
            "https://www.white-ibiza.com/wp-content/uploads/wellbeing-opener.jpg",
            "https://ae01.alicdn.com/kf/HTB10Nk9eDnI8KJjy0Ffq6AdoVXar/Ceremokiss-Summer-Sexy-Club-Swimwear-Women-Bikini-Sets-Stripes-Bandage-Swimsuit-Push-Up-Bathing-Suit-Brazilian.jpg",
            "https://www.dhresource.com/0x0s/f2-albu-g5-M01-8E-87-rBVaI1k-RhKAXE7jAAaagwlQR_4251.jpg/velvet-bikini-2017-sexy-micro-bikinis-women.jpg",
            "https://www.dhresource.com/albu_226507030_00-1.0x0/halter-dropshipping.jpg",
            "https://thumbs.dreamstime.com/b/bikini-girl-sitting-seaside-rock-15452009.jpg",
            "https://i.pinimg.com/originals/c4/81/e0/c481e0eca617af42933ff5a8c747dc67.jpg",
            "https://www.glifting.co.uk/wp-content/uploads/2017/03/Glifting-Girls-Ibiza-2017-2-1024x683.jpg",
            "https://c1.staticflickr.com/5/4109/5447991626_2121c39120_b.jpg",
        ]
        
        
        
        for url in urls {
            let newItem = PhotoFromInternetModel()
            newItem.url = url
            
            items.append(newItem)
        }
        
        collectionView.autoScroll = false
        collectionView.tapToScroll = true
        collectionView.endlessScrolling = false
        
        testView2.gradientAngle = 0.2
        testView2.progressValue = 0.5
    }

    @IBAction func fillCollection(_ sender: Any) {
        collectionView.items = items
    }
    
    @IBAction func aspectCnahge(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            collectionView.contentMode = .scaleAspectFit
            sender.setTitle("aspect fit", for: .normal)
        } else {
            collectionView.contentMode = .scaleAspectFill
            sender.setTitle("aspect fill", for: .normal)
        }
    }
    
    //==================================================
    
    @IBOutlet weak var testView2: ProgressWithGradient2!
    @IBOutlet weak var progressViewWidth: NSLayoutConstraint!
    
    @IBAction func progressChanged(_ sender: UISlider) {
        testView2.progressValue = CGFloat(sender.value)
    }
    
    @IBAction func changeToMin(_ sender: Any) {
        UIView.animate(withDuration: 0.7) {
            self.testView2.progressValue = 0
        }
    }
    
    @IBAction func changeToMax(_ sender: Any) {
       

        self.testView2.progressValue = 1
        
    }
    
    @IBAction func cjangeProgressViewSize(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.7) {
            self.progressViewWidth.constant = sender.isSelected ? 200 : 160
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    
    
    
}

