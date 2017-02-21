//
// Created by Zinets Victor on 2/21/17.
//

#import "ImageViewControl.h"
#import "TNImageDownloader.h"

@interface ImageViewControl (Url) <TNImageDownloaderDelegate>
- (void)loadImageForUrl:(NSString *)imageUrl;
@end