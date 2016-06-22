//
//  FbAnCell.m
//  testFbAn
//
//  Created by Zinets Victor on 6/16/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "FbAnCell2.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import "UrlImageView2.h"

@interface FbAnCell2 () <FBNativeAdDelegate>
@end

@implementation FbAnCell2

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        FBNativeAd *nativeAd =
        [[FBNativeAd alloc] initWithPlacementID:@"503847473144516_503862206476376"];
        nativeAd.delegate = self;
        [nativeAd loadAd];
    }
    return self;
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
   
    FBNativeAdView *adView = [FBNativeAdView nativeAdViewWithNativeAd:nativeAd
                                                             withType:FBNativeAdViewTypeGenericHeight300];
    adView.frame = self.bounds;
    [self.contentView addSubview:adView];
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NSLog(@"Ad failed to load with error: %@", error);
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, nativeAd);
}

@end
