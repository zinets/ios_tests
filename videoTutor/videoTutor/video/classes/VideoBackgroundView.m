//
//  VideoBackgroundView.m
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "VideoBackgroundView.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoBackgroundView()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation VideoBackgroundView

#pragma mark getters -

-(AVPlayer *)player {
    return self.playerLayer.player;
}

-(AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer layer];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        _playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor = [UIColor brownColor].CGColor;
        
        _playerLayer.player = [[AVPlayer alloc] initWithPlayerItem:nil];
    }
    return _playerLayer;
}

-(void)setMedia:(NSString *)media {
    NSURL *url = [[NSBundle mainBundle] URLForResource:media withExtension:nil];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark -

- (void)commonInit {
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark public playing -

- (void)endOfVideo:(NSNotification *)notification {
    if (self.player.currentItem == notification.object) {
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
}

- (void)play {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player play];
    }
}

- (void)stop {
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
}


@end
