//
// Created by Zinets Viktor on 5/16/17.
// Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "videoCell.h"
#import "UrlImageView2.h"

static void *PlayerStatusContext = &PlayerStatusContext;

@interface VideoCell ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UrlImageView2 *playerPlaceholder;
@property (nonatomic) BOOL loaded;
@end

@implementation VideoCell

- (AVPlayer *)player {
    return [self.playerLayer player];
}

- (void)setPlayer:(AVPlayer *)player {
    [self.playerLayer setPlayer:player];
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer layer];
        _playerLayer.frame = self.bounds;
    }
    return _playerLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.playerPlaceholder];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.playerPlaceholder];
    }
    return self;
}

- (UrlImageView2 *)playerPlaceholder {
    if (!_playerPlaceholder) {
        _playerPlaceholder = [[UrlImageView2 alloc] initWithFrame:self.bounds];
        _playerPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _playerPlaceholder.contentMode = UIViewContentModeScaleAspectFit;

        _playerPlaceholder.hidden = NO;
    }
    return _playerPlaceholder;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    self.playerPlaceholder.placeholderView = backgroundView;
}

- (void)loadVideo:(NSString *)videoUrl preview:(NSString *)previewUrl {
    if (self.loaded) {
        [self unloadVideo];
    }

    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
    self.playerPlaceholder.image = nil;
    [self.playerPlaceholder loadImageFromUrl:previewUrl];

    NSURL *url = [NSURL URLWithString:videoUrl];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];

    [self.player addObserver:self forKeyPath:@"status" options:0 context:&PlayerStatusContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    if (self.autostart) {
        [self.player play];
    }

    self.loaded = YES;
}

- (void)unloadVideo {
    [self.player pause];

    [self.player removeObserver:self forKeyPath:@"status" context:&PlayerStatusContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    self.player = nil;
    [self updateUI];

    [self.playerLayer removeFromSuperlayer];
    self.loaded = NO;
}

- (void)endOfVideo:(id)endOfVideo {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)play {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player play];
    }
}

- (BOOL)pause {
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self.player pause];
    } else {
        [self.player play];
    }
    return self.player.timeControlStatus == AVPlayerTimeControlStatusPaused;
}

- (void)stop {
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
}

- (void)updateUI {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        _playerPlaceholder.hidden = YES;
    } else {
        _playerPlaceholder.hidden = NO;
        _playerPlaceholder.image = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context == PlayerStatusContext) {
        AVPlayer *player = (AVPlayer *) object;
        AVPlayerStatus status = [player status];
        switch (status) {
            case AVPlayerStatusFailed:
                NSLog(@"error: %@", [player error]);
                break;
            case AVPlayerStatusReadyToPlay:
                [self updateUI];
                break;
            case AVPlayerStatusUnknown:
                break;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

@end