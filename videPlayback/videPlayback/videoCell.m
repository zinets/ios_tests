//
// Created by Zinets Viktor on 5/16/17.
// Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "videoCell.h"
#import "UrlImageView2.h"

static void *PlayerStatusContext = &PlayerStatusContext;

@interface VideoCell ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UrlImageView2 *playerPlaceholder;
@end

@implementation VideoCell

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.playerPlaceholder];
    }
    return self;
}

- (UrlImageView2 *)playerPlaceholder {
    if (!_playerPlaceholder) {
        _playerPlaceholder = [[UrlImageView2 alloc] initWithFrame:self.bounds];
        _playerPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _playerPlaceholder.contentMode = UIViewContentModeScaleAspectFit;

        _playerPlaceholder.hidden = YES;
    }
    return _playerPlaceholder;
}

- (void)loadVideo:(NSString *)videoUrl preview:(NSString *)previewUrl {
    [self stopPlaying];

    [self.playerPlaceholder loadImageFromUrl:previewUrl];

    NSURL *url = [NSURL URLWithString:videoUrl];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];

    [self.player addObserver:self forKeyPath:@"status" options:0 context:&PlayerStatusContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    if (self.autostart) {
        [self.player play];
    }
    [self updateUI];
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

- (void)stopPlaying {
    [self.player removeObserver:self forKeyPath:@"status" context:&PlayerStatusContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)updateUI {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self layer].opacity = 1;
        _playerPlaceholder.hidden = NO;
    } else {
        [self layer].opacity = 0;
        _playerPlaceholder.hidden = YES;
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