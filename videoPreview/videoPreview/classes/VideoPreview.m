//
// Created by Zinets Viktor on 5/17/17.
// Copyright (c) 2017 iCupid. All rights reserved.
//

#import "VideoPreview.h"

#import <TNURLImageView/TNURLImageView.h>


@interface AVPlayer (TNPlayingStatus)
- (BOOL)isPlaying;
@end

@implementation AVPlayer (TNPlayingStatus)
- (BOOL)isPlaying {
    return self.rate > 0.0f && self.error == nil;
}
@end

static void *PlayerStatusContext = &PlayerStatusContext;

@interface VideoPreview ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) TNImageView *playerPlaceholder;
@property (nonatomic) BOOL loaded;
@end

@implementation VideoPreview

// доступ к плееру - на самом деле доступ к экземпляру видео-проигрывающего слоя
- (AVPlayer *)player {
    return [self.playerLayer player];
}

- (void)setPlayer:(AVPlayer *)player {
    if (self.player) {
        [self.player removeObserver:self forKeyPath:@"status" context:&PlayerStatusContext];
    }
    [self.playerLayer setPlayer:player];
    [self.player addObserver:self forKeyPath:@"status" options:0 context:&PlayerStatusContext];
}

// геттер для проигрывающего слоя для нормальной "выгрузки" видео (если предполагается использование в ячейках и реюзание
- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer layer];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

        _playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _playerLayer;
}

- (TNImageView *)playerPlaceholder {
    if (!_playerPlaceholder) {
        _playerPlaceholder = [[TNImageView alloc] initWithFrame:self.bounds];
        _playerPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _playerPlaceholder.contentMode = UIViewContentModeScaleAspectFill;
        
        _playerPlaceholder.hidden = NO;
        _playerPlaceholder.allowLoadingAnimation = NO;
    }
    return _playerPlaceholder;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    self.playerPlaceholder.placeholderView = backgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addSubview:self.playerPlaceholder];
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    // єтот нотіфікатор прідет? когда проігриваніе упрется в конец файла - чтоби перемотать на начало
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // этот нотификатор дернется несколько раз при проигрывании - я использую его, чтобы убирать пласхолдер не перед началом проигрывания (визуально - мелькание белого экрана до начала проигрывания), а при проигрывании первых кадров
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeChanged:) name:AVPlayerItemTimeJumpedNotification object:nil];
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"status" context:&PlayerStatusContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (void)loadVideo:(NSString *)videoUrl preview:(NSString *)previewUrl {
    // на случай последовательных загрузок видео
    if (self.loaded) {
        [self unloadVideo];
    }

    // идеальный флов - сразу есть картинка-заглушка, потом показываетс превью видео и уже потом показывается первый кадр видео (и оно стартует даже возможно, если настройка)
    self.playerPlaceholder.image = nil;
    if (previewUrl) {
        [self.playerPlaceholder loadImageFromUrl:previewUrl];
        self.playerPlaceholder.hidden = NO;
    }
    
    self.playerLayer.hidden = self.suppressVideoLoad; // очевидно что скорее всего видимо я добавлял свойство suppressVideoLoad, но накуа?.. не уверен, что ничего не сломается при его использовании (не проверял)
    
    if (!self.suppressVideoLoad) {
        NSURL *url = [[NSURL alloc] initWithString:videoUrl];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
        
        [self setPlayer:[[AVPlayer alloc] initWithPlayerItem:playerItem]];
    }

    self.loaded = YES;
}

- (void)unloadVideo {
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.loaded = NO;
}

- (void)endOfVideo:(NSNotification *)notification {
    if (self.player.currentItem == notification.object) {        
        if (self.loop) {
            [self.player seekToTime:kCMTimeZero];
            [self.player play];
        }
    }
}

- (void)timeChanged:(NSNotification *)notification {
    if (self.player.currentItem == notification.object && !self.playerPlaceholder.hidden) {
        AVPlayerItem *item = self.player.currentItem;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            self.playerPlaceholder.hidden = YES;
        }
    }
}

- (void)play {
    if (self.player.status == AVPlayerStatusReadyToPlay &&
            !self.player.isPlaying) {
        [self.player play];
    }
}

- (BOOL)pause {
    if (self.player.isPlaying) {
        [self.player pause];
    } else {
        [self.player play];
    }
    return !self.player.isPlaying;
}

// осталось без дела - нет метода "стоп", стоп - это остановка проигрывания и перемотка на начало..
- (void)stop {
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
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
            case AVPlayerStatusReadyToPlay: {
                AVPlayerItem *curItem = player.currentItem;
                AVAsset *asset = curItem.asset;
                NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
                if (tracks.count > 0) {
                    AVAssetTrack *track = [tracks firstObject];
                    self.playerLayer.affineTransform = track.preferredTransform;
                    [self.player seekToTime:kCMTimeZero];
                    [self.player pause];
                    
                    if (self.autostart) {
                        [self play];
                    }
                }
                break;
            }
            case AVPlayerStatusUnknown:
                break;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

@end
