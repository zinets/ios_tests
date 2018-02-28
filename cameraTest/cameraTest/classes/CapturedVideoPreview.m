//
//  CapturedVideoPreview.m
//  cameraTest
//
//  Created by Zinets Victor on 2/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "CapturedVideoPreview.h"
#import <AVFoundation/AVFoundation.h>

static const NSString *PlayerStatusContext;

@interface CapturedVideoPreview()
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic, strong) AVPlayerLayer *videoPlayerLayer;
@end

@implementation CapturedVideoPreview

+ (instancetype)videoPreviewWithUrl:(NSURL *)videoUrl {
    return [[self alloc] initWithUrl:videoUrl];
}

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        self.videoPlayer = [AVPlayer playerWithURL:url];
        
        [self.videoPlayer addObserver:self forKeyPath:@"status"
                              options:NSKeyValueObservingOptionInitial
                              context:&PlayerStatusContext];

        self.videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        self.videoPlayerLayer.frame = self.bounds;
        [self.layer addSublayer:self.videoPlayerLayer];
    }
    return self;
}

-(void)dealloc {
    [self.videoPlayer removeObserver:self forKeyPath:@"status" context:&PlayerStatusContext];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.videoPlayerLayer.frame = self.bounds;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (context == &PlayerStatusContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.videoPlayer status] == AVPlayerItemStatusReadyToPlay) {
                self.playControl.enabled = YES;
            } else {
                self.playControl.enabled = NO;
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}


#pragma mark - control

- (void)play {
    [self.videoPlayer play];
}

- (void)pause {
    [self.videoPlayer pause];
}


//if (!self.isObservingActive) {
//    [self.videoPlayer addObserver:self forKeyPath:@"status"
//                          options:NSKeyValueObservingOptionInitial
//                          context:&ItemStatusContext];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(playerItemDidReachEnd:)
//                                                 name:AVPlayerItemDidPlayToEndTimeNotification
//                                               object:self.videoPlayer];
//    
//};

@end
