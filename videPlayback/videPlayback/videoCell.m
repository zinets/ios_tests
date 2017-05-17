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

// доступ к плееру - на самом деле доступ к экземпляру видео-проигрывающего слоя
- (AVPlayer *)player {
    return [self.playerLayer player];
}

- (void)setPlayer:(AVPlayer *)player {
    [self.playerLayer setPlayer:player];
}

// геттер для проигрывающего слоя для нормальной "выгрузки" видео (если предполагается использование в ячейках и реюзание
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
    // на случай последовательных загрузок видео
    if (self.loaded) {
        [self unloadVideo];
    }
    // слой добавляется при каждой загрузке видео - и удаляется при выгрузке
    [self.layer insertSublayer:self.playerLayer atIndex:0];

    // идеальный флов - сразу есть картинка-заглушка, потом показываетс превью видео и уже потом показывается первый кадр видео (и оно стартует даже возможно, если настройка)
    self.playerPlaceholder.image = nil;
    [self.playerPlaceholder loadImageFromUrl:previewUrl];

    NSURL *url = [NSURL URLWithString:videoUrl];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];

    [self.player addObserver:self forKeyPath:@"status" options:0 context:&PlayerStatusContext];
    // для заколцовывания видео - слушаем об событии "доиграли до конца" и после перемотки стартуем плей.. топовато, а иначе никак
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    if (self.autostart) {
        [self.player play];
    }

    self.loaded = YES;
}

- (void)unloadVideo {
    [self.player pause];
    // так как я толком не придумал более красивый механизм (точнее есть простой механизм старт-стоп, но для нашего применения в чячейках и реюзания он не очень подходит визуально
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

// осталось без дела - нет метода "стоп", стоп - это остановка проигрывания и перемотка на начало..
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