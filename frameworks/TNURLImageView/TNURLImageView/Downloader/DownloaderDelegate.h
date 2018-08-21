//
//  DownloaderDelegate.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderDelegate <NSObject>

- (void)downloader:(id)downloader didDownloadDataToURL:(NSURL *)tempURL sourceURL:(NSString *)sourceURL;
- (void)downloader:(id)downloader didFinishDownloadingURL:(NSString *)url withError:(NSError *)error;
@optional
- (void)downloader:(id)downloader didDownloadDataOfURL:(NSString *)urlString withProgress:(float)progress;

@end
