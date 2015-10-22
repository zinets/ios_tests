//
//  UIUrlImageView.h
//  testCachedImages
//
//  Created by Zinetz Victor on 26.02.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIUrlImageView : UIImageView <NSURLConnectionDelegate> {
    NSURLConnection * _connection;
    NSMutableData * _data;
    UIActivityIndicatorView * activity;
}

@property (strong, nonatomic) NSString * url;

@end
