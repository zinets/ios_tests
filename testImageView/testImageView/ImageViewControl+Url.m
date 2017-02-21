//
// Created by Zinets Victor on 2/21/17.
//

#import "ImageViewControl+Url.h"

@implementation ImageViewControl (Url)

- (void)loadImageForUrl:(NSString *)imageUrl {
    if (self.loadingView) {
        self.userInteractionEnabled = NO;
        self.loadingView.center = (CGPoint){CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
        [self addSubview:self.loadingView];
    }
    [[TNImageDownloader sharedInstance] getImagesForUrls:@[imageUrl] observer:self];
}

#pragma mark - download delegation

- (void)imageDownloader:(TNImageDownloader *)imageDownloader didDownloadImage:(UIImage *)image forUrl:(NSString *)imageUrl {
    [self.loadingView removeFromSuperview];
    self.userInteractionEnabled = YES;
    self.image = image;
}

- (void)imageDownloader:(TNImageDownloader *)imageDownloader didFailDownloadImageForUrl:(NSString *)imageUrl withError:(NSError *)error {
    [self.loadingView removeFromSuperview];
    self.userInteractionEnabled = YES;
}

- (void)imageDownloader:(TNImageDownloader *)imageDownloader didDownloadDataWithProgress:(float)progress {
    if ([self.loadingView respondsToSelector:@selector(setProgress:animated:)]) {
        [self.loadingView setProgress:progress animated:YES];
    }
}


@end