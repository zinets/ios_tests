//
//  ViewController.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble
import FS

class StartViewController: UIViewController {
    
    @IBOutlet weak var startImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var viewToAnimate: UIView!
    

    var transition: TransitionCoordinator!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "present":
            segue.destination.modalPresentationStyle = .custom
        case "push":
            transition = TransitionCoordinator()
            self.navigationController?.delegate = transition
        default:
            break
        }
        
    }
    
    @IBAction func showFS(_ sender: Any) {
//        let destination = UIStoryboard(name: "FullScreenController", bundle: nil).instantiateViewController(withIdentifier: "FullScreenController") as! FullScreenController
        let destination = FullScreenController()
        destination.register(UINib(nibName: "FullScreenPhotoCell", bundle: nil), forCellWithReuseIdentifier: FullScreenPhotoCell.reusableIdentifier)
        destination.dataProvider = { [weak self] in
            return self?.fullScreenItems() ?? []
        }
        destination.onIndexChanged = { index, num in
            print(index, num)
        }
        destination.startImage = startImageView.image
        let sourceFrame = self.view.window!.convert(startImageView.frame, from: startImageView.superview)
        destination.startFrame = sourceFrame
        
        destination.pageIndex = 1
        
//        destination.dismissAnimator = FullScreenDismissAnimator() //DismissAnimatorLikeFB()
        self.present(destination, animated: true, completion: nil)
    }
    
    private func fullScreenItems() -> [FullScreenItem] {
        let items = [
            "https://s1.dmcdn.net/v/GP4ae1NVKdS0rpycO/x1080",
            "https://i.pinimg.com/originals/f1/6c/75/f16c750775bbfc101aec1ba53c8c0678.jpg",        
            "https://i1.ytimg.com/vi/0WI7En7heSA/maxresdefault.jpg"].map { (url) -> FullScreenItem in
                return FullScreenItem(cellReuseId: FullScreenPhotoCell.reusableIdentifier, photoUrl: url, videoUrl: nil)
        }
        return items
    }
}





extension StartViewController: Transitionable {
    
    var view1: UIView? {
        return self.viewToAnimate
    }
}
