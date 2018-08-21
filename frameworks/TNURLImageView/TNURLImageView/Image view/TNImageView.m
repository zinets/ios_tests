//
//  TNImageView.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "TNImageView.h"
#import "ImageDataProvider.h"
#import "UIImage+Positioning.h"
#import "DeferredWatcher.h"


@interface TNImageView () <ImageDataProviderDelegate>

@property (strong, nonatomic) NSString *currentURL;
@property (assign, nonatomic) ImageType currentImageType;
@property (strong, nonatomic) NSMutableArray <DeferredWatcher *> *deferredWatchers;

@property(nonatomic, strong) UIImageView *animatedImageView;

@end


@implementation TNImageView


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.clipsToBounds = YES;
    self.allowLoadingAnimation = YES;
    self.hasToClearImage = YES;
    self.deferredWatchers = [NSMutableArray new];
}


#pragma mark - dealloc
- (void)dealloc {
    [self cancelLoading];
}


#pragma mark -
- (NSString *)currentImageURLString {
    return _currentURL;
}


#pragma mark - url loading
- (void)loadImageFromUrl:(NSString *)url {
    [self loadImageFromUrl:url withType:ImageTypeNormal];
}


- (void)loadImageFromUrl:(NSString *)url withType:(ImageType)type {
    [self loadImageFromUrl:url withType:type forceLoad:NO];
}


- (void)loadImageFromUrl:(NSString *)url forceLoad:(BOOL)forceLoad {
    [self loadImageFromUrl:url withType:ImageTypeNormal forceLoad:forceLoad];
}


- (void)loadImageFromUrl:(NSString *)url withType:(ImageType)type forceLoad:(BOOL)forceLoad {
    
    // приступать к обработке нужно если урл поменялся или нужно принудительно перезагрузить картинку (или обнулить)
    if (![url isEqualToString:_currentURL] || type != _currentImageType || forceLoad) {
        
        self.placeholderView.alpha = 1;
        self.overlayView.alpha = 0;
        
        if (self.hasToClearImage) {
            self.image = nil;
        }
        
        _currentURL = url;
        
        _currentImageType = type;
        
        if (url && url.length > 0) { // потому что внезапно приходит пустая строка
            self.loadingView.alpha = 1;
            if ([self.loadingView respondsToSelector:@selector(startAnimating)]) {
                [self.loadingView performSelector:@selector(startAnimating)];
            }
            
//            // для включеного ресайза+кеширования, перед загрузкой оригинала картинки, ищем в кеше отресайзеную
//            if (self.shouldCacheResizedImage && !CGSizeEqualToSize(CGSizeZero, self.resizeImageToSize)) {
//                NSString *resizedName = self.resizedName;
//                UIImage *resized = nil;
//                if (resizedName) {
//                    resized = [TNCache imageForKey:resizedName];
//                }
//                if (resized) {
//                    self.image = resized;
//                    return;
//                }
//            }
            [[ImageDataProvider sharedInstance] getImagesForUrls:@[url] watcher:self imageType:type];
        } else {
            self.loadingView.alpha = 0;
            if ([self.loadingView respondsToSelector:@selector(stopAnimating)]) {
                [self.loadingView performSelector:@selector(stopAnimating)];
            }
            [self cancelLoading];
        }
    }
}

- (BOOL)haveImageForUrl:(NSString *)url {
    BOOL retVal = [[ImageDataProvider sharedInstance] haveImageForUrl:url];
    return retVal;
}


- (void)cancelLoading {
    if (_currentURL) {
        [[ImageDataProvider sharedInstance] removeWatcher:self forImageUrl:_currentURL];
    }
}


#pragma mark - setImage
- (void)setImage:(UIImage *)image forUrl:(NSString *)url {
    if (!CGSizeEqualToSize(CGSizeZero, self.resizeImageToSize)) {
        __weak __typeof__(self) weakSelf = self;;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *resized = nil;
//            if (self.shouldCacheResizedImage) {
//                resized = [UIImage getImageFromCache:[weakSelf resizedName] andCreateNewIfNotExist:^UIImage *{
//                    if (UIViewContentModeScaleAspectFit == weakSelf.contentMode) {
//                        return [image fitInSize:weakSelf.resizeImageToSize];
//                    } else {
//                        return [image fillInSize:weakSelf.resizeImageToSize];
//                    }
//                }];
//            } else {
                if (UIViewContentModeScaleAspectFit == self.contentMode) {
                    resized = [image fitInSize:weakSelf.resizeImageToSize];
                } else {
                    resized = [image fillInSize:weakSelf.resizeImageToSize];
                }
//            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf performImageLoadedBlockAndSetImage:resized forUrl:url];
            });
        });
    } else {
        [self performImageLoadedBlockAndSetImage:image forUrl:url];
    }
}

- (void)performImageLoadedBlockAndSetImage:(UIImage *)image forUrl:(NSString *)imageUrl {
    if ([_currentURL isEqualToString:imageUrl]) {
        if (self.onImageLoaded) {
            __weak __typeof__(self) weakSelf = self;;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                UIImage *result  = nil;
                // в фаьрике прилетел креш
                // __59-[UrlImageView2 performImageLoadedBlockAndSetImage:forUrl:]_block_invoke + 4296046520
                // видимо бывают случаи когда в этом месте блок пустой уже
                
                // переворот будет для всех фоток в -(void)setImage:(UIImage *)image
                if (weakSelf.onImageLoaded) {
                    result = weakSelf.onImageLoaded(image);
                }
                // синхронно - нинада! т.к. метод вызывается в главном потоке из setImage:(UIImage *)image forUrl:(NSString *)url
                // стакало сирч выдачу
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.image = result;
                });
            });
        } else {
            self.image = image;
        }
    }
}

- (void)setImage:(UIImage *)image {
    self.loadingView.alpha = 0;
    if ([self.loadingView respondsToSelector:@selector(stopAnimating)]) {
        [self.loadingView performSelector:@selector(stopAnimating)];
    }
    
    if (image == nil) {
        _currentURL = nil;
        _currentImageType = ImageTypeNormal;
        [self cancelLoading];
        [super setImage:nil];
        
        self.placeholderView.alpha = 1;
    } else {
        //поворачиваем изображения если они не выровнены на сервере
        if (image.imageOrientation != UIImageOrientationUp) {
            image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:(UIImageOrientationUp)];
        }
        
        self.placeholderView.alpha = 0;
        self.overlayView.alpha = 1;
        if (self.allowLoadingAnimation) {
            CATransition *t = [CATransition animation];
            t.duration = self.loadingAnimationDuration;
            [self.layer addAnimation:t forKey:nil];
        }
        [super setImage:image];
    }
    if (self.onLoadCompleted) {
        self.onLoadCompleted(image.size);
    }

    if (self.animatedImageView) {
        [self.animatedImageView removeFromSuperview];
        self.animatedImageView = nil;
    }
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    if (!self.image || contentMode == self.contentMode) {
        [super setContentMode:contentMode];

        return;
    }

    CGSize viewSize = self.bounds.size;
    CGSize imageSize = self.image.size;
    CGFloat arX = imageSize.width / viewSize.width;
    CGFloat arY = imageSize.height / viewSize.height;

    CGFloat fillAR = MIN(arX, arY);
    CGSize fillSize = (CGSize){imageSize.width / fillAR, imageSize.height / fillAR};
    CGPoint fillOrigin = (CGPoint){(viewSize.width - fillSize.width) / 2, (viewSize.height - fillSize.height) / 2};

    CGFloat fitAR = MAX(arX, arY);
    CGSize fitSize = (CGSize){imageSize.width / fitAR, imageSize.height / fitAR};
    CGPoint fitOrigin = (CGPoint){(viewSize.width - fitSize.width) / 2, (viewSize.height - fitSize.height) / 2};

    if (!self.animatedImageView) {
        self.animatedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.animatedImageView.contentMode = UIViewContentModeScaleToFill;
        self.animatedImageView.clipsToBounds = YES;
    }

    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFill:
            self.animatedImageView.frame = (CGRect){fillOrigin, fillSize};
            break;
        case UIViewContentModeScaleAspectFit:
            self.animatedImageView.frame = (CGRect){fitOrigin, fitSize};
            break;
        case UIViewContentModeScaleToFill:
            self.animatedImageView.frame = self.bounds;
            break;
        case UIViewContentModeCenter:
            self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, (viewSize.height - imageSize.height) / 2}, self.image.size};
            break;
        case UIViewContentModeRedraw:
            break;
        case UIViewContentModeTop:
            self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, 0}, self.image.size};
            break;
        case UIViewContentModeBottom:
            self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, viewSize.height - imageSize.height}, self.image.size};
            break;
        case UIViewContentModeLeft:
            self.animatedImageView.frame = (CGRect){{0, (viewSize.height - imageSize.height) / 2}, self.image.size};
            break;
        case UIViewContentModeRight:
            self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, (viewSize.height - imageSize.height) / 2}, self.image.size};
            break;
        case UIViewContentModeTopLeft:
            self.animatedImageView.frame = (CGRect){CGPointZero, self.image.size};
            break;
        case UIViewContentModeTopRight:
            self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, 0}, self.image.size};
            break;
        case UIViewContentModeBottomLeft:
            self.animatedImageView.frame = (CGRect){{0, viewSize.height - imageSize.height}, self.image.size};
            break;
        case UIViewContentModeBottomRight:
            self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, viewSize.height - imageSize.height}, self.image.size};
            break;
    }

    self.animatedImageView.image = self.image;
    [self addSubview:self.animatedImageView];

    switch (contentMode) {
        case UIViewContentModeScaleAspectFill: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect) {fillOrigin, fillSize};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];

            break;
        }
        case UIViewContentModeScaleAspectFit: {
            [super setContentMode:contentMode];

            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect) {fitOrigin, fitSize};
            } completion:^(BOOL finished) {
                [self.animatedImageView removeFromSuperview];
            }];

            break;
        }
        case UIViewContentModeScaleToFill: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = self.bounds;
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];

            break;
        }
        case UIViewContentModeCenter: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, (viewSize.height - imageSize.height) / 2}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeRedraw:
            [super setContentMode:contentMode];
            [self.animatedImageView removeFromSuperview];
            break;
        case UIViewContentModeTop: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, 0}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeBottom: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, viewSize.height - imageSize.height}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeLeft: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{0, (viewSize.height - imageSize.height) / 2}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeRight: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, (viewSize.height - imageSize.height) / 2}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeTopLeft: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){CGPointZero, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeTopRight: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, 0}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeBottomLeft: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{0, viewSize.height - imageSize.height}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeBottomRight: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, viewSize.height - imageSize.height}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
    }
}

#pragma mark - setters
- (void)setPlaceholderView:(UIView *)placeholder {
    if (placeholder == _placeholderView) {
        return;
    }
    if (_placeholderView) {
        [_placeholderView removeFromSuperview];
    }
    _placeholderView = placeholder;
    _placeholderView.frame = self.bounds;
    _placeholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _placeholderView.alpha = self.image == nil ? 1.0 : 0.0;
    [self addSubview:_placeholderView];
}

- (void)setLoadingView:(UIView *)loadingView {
    if (loadingView != _loadingView) {
        [_loadingView removeFromSuperview];
        _loadingView = loadingView;
        _loadingView.center = (CGPoint){CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        _loadingView.alpha = 0;
        [self addSubview:_loadingView];
    }
}

- (void)setOverlayView:(UIView *)overlayView {
    if (overlayView != _overlayView) {
        [_overlayView removeFromSuperview];
        _overlayView = overlayView;
        _overlayView.center = (CGPoint){CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        // если оверлей засетили - показываем всегда, когда есть картинка
        _overlayView.alpha = self.image ? 1 : 0;
        [self addSubview:_overlayView];
    }
}



#pragma mark - data provider callback
- (void)dataProvider:(id)dataProvider didLoadImage:(UIImage *)image fromURL:(NSString *)url {
    __weak __typeof__(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
#ifdef DEBUG_SLOW_IMAGE_LOAD
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf setImage:image forUrl:imageUrl];
        });
#else
        [weakSelf setImage:image forUrl:url];
#endif
    }];
}


- (void)dataProvider:(id)dataProvider didFailLoadingImageFromURL:(NSString *)url {
    __weak __typeof__(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (weakSelf.onLoadError) {
            weakSelf.onLoadError();
        }
    }];
}


#pragma mark - warm up the cache!
+ (void)preloadImages:(NSArray <NSString *> *)urlList {
    [self preloadImages:urlList withType:ImageTypeNormal];
}

+ (void)preloadImages:(NSArray <NSString *> *)urlList withType:(ImageType)type {
    [[ImageDataProvider sharedInstance] getImagesForUrls:urlList watcher:nil priority:DownloaderPriorityLow imageType:type];
}


#pragma mark - public
- (void)getImageWithType:(ImageType)type onImageLoaded:(void (^)(UIImage *))onImageLoaded {
    if (_currentURL) {
        DeferredWatcher *watcher = [[DeferredWatcher alloc] initWithType:type url:_currentURL];
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(watcher) weakWatcher = watcher;
        watcher.callback = ^void(UIImage *image) {
            if (onImageLoaded) {
                onImageLoaded(image);
            }
            [weakSelf.deferredWatchers removeObject:weakWatcher];
        };
        [self.deferredWatchers addObject:watcher];
    } else {
        if (onImageLoaded) {
            onImageLoaded(nil);
        }
    }
}


@end
