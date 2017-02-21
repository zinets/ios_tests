//
// Created by Zinets Victor on 2/21/17.
//

#import "ImageViewControl+Url.h"

@implementation ImageViewControl (Url)

- (void)loadImageForUrl:(NSString *)imageUrl {
    [[TNImageDownloader sharedInstance] getImagesForUrls:@[imageUrl] observer:self];
}

#pragma mark - download delegation

- (void)imageDownloader:(TNImageDownloader *)imageDownloader didDownloadImage:(UIImage *)image forUrl:(NSString *)imageUrl {
    self.image = image;
}

- (void)imageDownloader:(TNImageDownloader *)imageDownloader didFailDownloadImageForUrl:(NSString *)imageUrl withError:(NSError *)error {

}


@end