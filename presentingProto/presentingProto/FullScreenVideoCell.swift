//
//  FullScreenVideoCell.swift
//
//  Created by Viktor Zinets on 22.07.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble
import TNURLImageView

class FullScreenVideoCell: UICollectionViewCell, AnyDiffAbleControl {
    
    @IBOutlet weak var videoPreview: VideoPreview! {
        didSet {
            videoPreview.contentMode = .scaleAspectFit
            videoPreview.delegate = self
//            videoPreview.autostart = true не, иначе не вызовется делегат и я не узнаю про готовность видео
            videoPreview.loop = true
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configure(_ item: AnyDiffAble) {
        if let item = item.payload as? FullScreenItem {
            videoPreview.loadVideo(item.videoUrl, preview: item.photoUrl)
        }
    }
    
    override func prepareForReuse() {
        isVideoReady = false
        videoPreview.unloadVideo()
    }
    
    private var isVideoReady = false
}

extension FullScreenVideoCell: MediaCell {
    
    func play() {
        if self.isVideoReady {
            self.videoPreview.play()
        }
    }
    func pause() {
        if self.isVideoReady {
            self.videoPreview.pause()
        }
    }
    func videoIsReadyToPlay(_ sender: Any!) {
        self.isVideoReady = true
        self.videoPreview.play()
    }
    
}
