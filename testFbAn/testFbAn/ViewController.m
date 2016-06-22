//
//  ViewController.m
//  testFbAn
//
//  Created by Zinets Victor on 6/16/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "FbAnCell.h"
#import "FbAnCell2.h"

@interface ViewController () <UICollectionViewDataSource, FBNativeAdDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *nativeAdView;
@property (nonatomic, strong) FBNativeAd *nativeAd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBAdSettings addTestDevice:@"3d0c1058dfc2188440657dc8e1fac03df79f9cbe"];
    
    FBNativeAd *nativeAd = [[FBNativeAd alloc] initWithPlacementID:@"503847473144516_503848586477738"];
    nativeAd.delegate = self;
    nativeAd.mediaCachePolicy = FBNativeAdsCachePolicyAll;
    [nativeAd loadAd];
    
//    [self.view addSubview:self.collectionView];
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
    CGRect frm = (CGRect){{5, 30}, self.view.frame.size};
    UIView *nativeAdView = [[UIView alloc] initWithFrame:frm];
    nativeAdView.layer.borderWidth = 2;
    [self.view addSubview:nativeAdView];
    
    
    NSString *titleForAd = nativeAd.title;
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){{5, 5}, {100, 20}}];
    label.text = titleForAd; [label sizeToFit];
    [nativeAdView addSubview:label];
    
    NSString *bodyTextForAd = nativeAd.body;
    label = [[UILabel alloc] initWithFrame:(CGRect){{5, 30}, {200, 20}}];
    label.text = bodyTextForAd; [label sizeToFit];
    [nativeAdView addSubview:label];
    
    FBAdImage *coverImage = nativeAd.coverImage;
    //    [coverImage loadImageAsyncWithBlock:^(UIImage * _Nullable image) {
    //
    //    }];
//    UrlImageView2 *iv = [[UrlImageView2 alloc] initWithFrame:(CGRect){{5, 50}, {300, 300}}];
//    iv.contentMode = UIViewContentModeScaleAspectFit;
//    [iv loadImageFromUrl:coverImage.url.absoluteString];
//    [nativeAdView addSubview:iv];
//    
//    FBAdImage *iconForAd = nativeAd.icon;
//    iv = [[UrlImageView2 alloc] initWithFrame:(CGRect){{5, 50}, {iconForAd.width, iconForAd.height}}];
//    iv.layer.borderColor = [UIColor redColor].CGColor;
//    iv.layer.borderWidth = 2;
//    [iv loadImageFromUrl:iconForAd.url.absoluteString];
//    [nativeAdView addSubview:iv];
//    
//    NSString *socialContextForAd = nativeAd.socialContext;
//    label = [[UILabel alloc] initWithFrame:(CGRect){{5, iv.frame.origin.y + iv.frame.size.height}, {200, 20}}];
//    label.text = socialContextForAd; [label sizeToFit];
//    [nativeAdView addSubview:label];
//    
//    struct FBAdStarRating appRatingForAd = nativeAd.starRating;
//    
//    btn = [[UIButton alloc] initWithFrame:(CGRect){{5, label.frame.origin.y + 30}, {200, 44}}];
//    NSString *titleForAdButton = nativeAd.callToAction;
//    [btn setTitle:titleForAdButton forState:(UIControlStateNormal)];
//    [btn addTarget:self action:@selector(onButtonTap:) forControlEvents:(UIControlEventTouchUpInside)];
//    btn.backgroundColor = [UIColor grayColor];
//    btn.enabled = NO;
//    [nativeAdView addSubview:btn];
    
    
    FBAdChoicesView *m = [[FBAdChoicesView alloc] initWithNativeAd:nativeAd expandable:NO];
    frm = m.frame;
    frm.origin = (CGPoint){100, 100};
    m.frame = frm;
    
   
    [nativeAdView addSubview:m];
    self.nativeAd = nativeAd;
    
    self.nativeAdView = nativeAdView;
    
    [nativeAd registerViewForInteraction:self.nativeAdView
                      withViewController:nil];

}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, nativeAd);
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = (CGSize){310, 300};
        layout.sectionInset = (UIEdgeInsets){5, 5, 5, 5};
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[FbAnCell class] forCellWithReuseIdentifier:@"FBcell"];
        [_collectionView registerClass:[FbAnCell2 class] forCellWithReuseIdentifier:@"FBcell2"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 1) {
        FbAnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FBcell" forIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.item == 3) {
        FbAnCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FBcell2" forIndexPath:indexPath];
        
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHex:random()];
        
        return cell;
    }
}


@end
