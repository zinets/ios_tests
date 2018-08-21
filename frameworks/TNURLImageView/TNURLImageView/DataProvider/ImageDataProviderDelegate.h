//
//  ImageDataProviderDelegate.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ImageDataProviderDelegate <NSObject>

- (void)dataProvider:(id)dataProvider didLoadImage:(UIImage *)image fromURL:(NSString *)url;
- (void)dataProvider:(id)dataProvider didFailLoadingImageFromURL:(NSString *)url;

@end
