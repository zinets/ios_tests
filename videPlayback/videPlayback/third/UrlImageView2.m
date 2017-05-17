//
//  UrlImageView2.m
//  MUIControls
//
//  Created by Zinets Victor on 10/1/15.
//  Copyright © 2015 iCupid. All rights reserved.
//

#import "UrlImageView2.h"
#import "TNImageDownloader.h"
#import "Utils.h"
#import "TNCache.h"
#import "UIImage+Thumbnails.h"
#import "UIImage+Cache.h"

#undef DEBUG_SLOW_IMAGE_LOAD
#ifdef DEBUG_SLOW_IMAGE_LOAD
#warning ACHTUNG!!! ONLY FOR TESTS!!!
#endif


@interface UrlImageView2 () <TNImageDownloaderDelegate>
@property (strong, nonatomic) NSString *currentURL;
@end

@implementation UrlImageView2

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.allowLoadingAnimation = YES;
        self.hasToClearImage = YES;
    }
    return self;
}

-(void)loadImageFromUrl:(NSString *)url forceLoad:(BOOL)forceLoad {
    if (![url isEqualToString:_currentURL] || forceLoad) {
        self.placeholderView.alpha = 1;
        self.overlayView.alpha = 0;
        if (self.hasToClearImage) {
            self.image = nil;
        }
        _currentURL = url;
        if (url && url.length > 0) { // потому что внезапно приходит пустая строка
            self.loadingView.alpha = 1;
            if ([self.loadingView respondsToSelector:@selector(startAnimating)]) {
                [self.loadingView performSelector:@selector(startAnimating)];
            }
            
            // для включеного ресайза+кеширования, перед загрузкой оригинала картинки, ищем в кеше отресайзеную
            if (self.shouldCacheResizedImage && !CGSizeEqualToSize(CGSizeZero, self.resizeImageToSize)) {
                NSString *resizedName = self.resizedName;
                UIImage *resized = nil;
                if (resizedName) {
                    resized = [TNCache imageForKey:resizedName];
                }
                if (resized) {
                    self.image = resized;
                    return;
                }
            }
            [[TNImageDownloader sharedInstance] getImagesForUrls:@[url] observer:self];
        } else {
            self.loadingView.alpha = 0;
            if ([self.loadingView respondsToSelector:@selector(stopAnimating)]) {
                [self.loadingView performSelector:@selector(stopAnimating)];
            }
            [self cancelLoading];
        }
    }
}

-(void)loadImageFromUrl:(NSString *)url {
    [self loadImageFromUrl:url forceLoad:NO];
}

- (NSString *)resizedName {
    if (!_currentURL) {
        return nil;
    }
    return [[NSString alloc] initWithFormat:@"%@__%@", _currentURL, NSStringFromCGSize(self.resizeImageToSize)];
}

#pragma mark - overrides

- (void)dealloc {
    [self cancelLoading];
}

- (void)cancelLoading {
    if (_currentURL) {
        [[TNImageDownloader sharedInstance] removeObserver:self forImageUrl:_currentURL];
    }
}

#pragma mark - setImage

- (void)setImage:(UIImage *)image forUrl:(NSString *)url {
    if (!CGSizeEqualToSize(CGSizeZero, self.resizeImageToSize)) {
        __weak UrlImageView2 *weakRef = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *resized = nil;
            if (self.shouldCacheResizedImage) {
                resized = [UIImage getImageFromCache:[weakRef resizedName] andCreateNewIfNotExist:^UIImage *{
                    if (UIViewContentModeScaleAspectFit == self.contentMode) {
                        return [image fitInSize:self.resizeImageToSize];
                    } else {
                        return [image fillInSize:self.resizeImageToSize];
                    }
                }];
            } else {
                if (UIViewContentModeScaleAspectFit == self.contentMode) {
                    resized = [image fitInSize:self.resizeImageToSize];
                } else {
                    resized = [image fillInSize:self.resizeImageToSize];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakRef performImageLoadedBlockAndSetImage:resized forUrl:url];
            });
        });
    } else {
        [self performImageLoadedBlockAndSetImage:image forUrl:url];
    }
}

- (void)performImageLoadedBlockAndSetImage:(UIImage *)image forUrl:(NSString *)imageUrl {
    if ([_currentURL isEqualToString:imageUrl]) {
        if (self.onImageLoaded) {
            __weak UrlImageView2 *weakRef = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                UIImage *result  = nil;
                // в фаьрике прилетел креш
                // __59-[UrlImageView2 performImageLoadedBlockAndSetImage:forUrl:]_block_invoke + 4296046520
                // видимо бывают случаи когда в этом месте блок пустой уже
                if (weakRef.onImageLoaded) {
                    //поворачиваем изображения если они не выровнены на сервере
                    if (image.imageOrientation != UIImageOrientationUp) {
                        UIImage *img = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:(UIImageOrientationUp)];
                        result = weakRef.onImageLoaded(img);
                    } else {
                        result = weakRef.onImageLoaded(image);
                    }
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    weakRef.image = result;
                });
            });
        } else {
            self.image = image;
        }
    }
}

-(void)setImage:(UIImage *)image {
    self.loadingView.alpha = 0;
    if ([self.loadingView respondsToSelector:@selector(stopAnimating)]) {
        [self.loadingView performSelector:@selector(stopAnimating)];
    }
    
    //поворачиваем изображения если они не выровнены на сервере
    if (image.imageOrientation != UIImageOrientationUp) {
        image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:(UIImageOrientationUp)];
    }
    
    if (image == nil) {
        _currentURL = nil;
        [self cancelLoading];
        [super setImage:image];
        self.placeholderView.alpha = 1;
    } else {
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
}

#pragma mark - setters

-(void)setPlaceholderView:(UIView *)placeholder {
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

-(void)setLoadingView:(UIView *)loadingView {
    if (loadingView != _loadingView) {
        [_loadingView removeFromSuperview];
        _loadingView = loadingView;
        _loadingView.center = (CGPoint){CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        _loadingView.alpha = 0;
        [self addSubview:_loadingView];
    }
}

-(void)setOverlayView:(UIView *)overlayView {
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

#pragma mark - download delegation

- (void)imageDownloader:(TNImageDownloader *)imageDownloader didDownloadImage:(UIImage *)image forUrl:(NSString *)imageUrl {
#ifdef DEBUG_SLOW_IMAGE_LOAD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setImage:image forUrl:imageUrl];
    });
#else
    [self setImage:image forUrl:imageUrl];
#endif
}

- (void)imageDownloader:(TNImageDownloader *)imageDownloader didFailDownloadImageForUrl:(NSString *)imageUrl withError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
#endif
    if (self.onLoadError) {
        self.onLoadError();
    }
}

//- (void)imageDownloader:(TNImageDownloader *)imageDownloader didDownloadDataWithProgress:(float)progress {
//}

#pragma mark - 

- (void)preloadImages:(NSArray <NSString *>*)urlList {
    [[TNImageDownloader sharedInstance] getImagesForUrls:urlList observer:nil priority:TNImageDownloaderPriorityLow];
}

@end
