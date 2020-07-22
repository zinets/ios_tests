//
//  ViewController.swift
//  presentingProto
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    private var transition = FullscreenTransition()
    @IBOutlet weak var startImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self.transition
        segue.destination.modalPresentationStyle = .custom
    }
    
    @IBAction func showFS(_ sender: Any) {
        let destination = UIStoryboard(name: "FullScreenController", bundle: nil).instantiateViewController(withIdentifier: "FullScreenController") as! FullScreenController
        destination.getFullscreenData = { [weak self] in
            return self?.fullScreenItems() ?? []
        }
        destination.startImage = startImageView.image
        let sourceFrame = self.view.window!.convert(startImageView.frame, from: startImageView.superview)
        destination.startFrame = sourceFrame
        
//        destination.transitioningDelegate = self
        self.present(destination, animated: true, completion: nil)
    }
    
    private func fullScreenItems() -> [FullScreenItem] {
        let items = ["https://lh3.googleusercontent.com/proxy/_Ab3_9S2lAbwbennlpHkVKTu1rer6yKf0aUPkoKwh71y1zZvyJlNRPJ5aVm-ZNIQpDKV5OO62-G7XLLw99wN",
        "https://i.pinimg.com/originals/f1/6c/75/f16c750775bbfc101aec1ba53c8c0678.jpg",
        "https://s1.dmcdn.net/v/GP4ae1NVKdS0rpycO/x1080",
        "https://i1.ytimg.com/vi/0WI7En7heSA/maxresdefault.jpg"].map { (url) -> FullScreenItem in
            return FullScreenItem(cellReuseId: FullScreenPhotoCell.reusableIdentifier, photoUrl: url, videoUrl: nil)
        }
        return items
    }
}

/*
https://lh3.googleusercontent.com/proxy/_Ab3_9S2lAbwbennlpHkVKTu1rer6yKf0aUPkoKwh71y1zZvyJlNRPJ5aVm-ZNIQpDKV5OO62-G7XLLw99wN
https://i.pinimg.com/originals/f1/6c/75/f16c750775bbfc101aec1ba53c8c0678.jpg
https://s1.dmcdn.net/v/GP4ae1NVKdS0rpycO/x1080
https://i1.ytimg.com/vi/0WI7En7heSA/maxresdefault.jpg
*/
