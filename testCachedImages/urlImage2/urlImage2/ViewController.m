//
//  ViewController.m
//  urlImage2
//
//  Created by Zinets Victor on 10/1/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "UrlImageView2.h"
#import "Utils.h"
#import "UIImage+ImageEffects.h"

@interface ViewController () {
    UrlImageView2 *iv;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    iv = [UrlImageView2 new];
    iv.frame = (CGRect){{30, 30}, {100, 100}};
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.onImageLoaded = ^(UIImage *img) {
//        img = [img applyBlur];
    };
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    loading.hidden = NO;
    borderControl(loading);
    iv.loadingView = loading;
    [self.view addSubview:iv];
    
    borderControl(iv);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:(CGRect){{30, 150}, {100, 44}}];
    [btn setTitle:@"load 1" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    [btn addTarget:self action:@selector(onLoad1:) forControlEvents:(UIControlEventTouchUpInside)];
    borderControl(btn);
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:(CGRect){{30, 200}, {100, 44}}];
    [btn setTitle:@"load 2" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onLoad2:) forControlEvents:(UIControlEventTouchUpInside)];
    borderControl(btn);
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:(CGRect){{150, 200}, {100, 44}}];
    [btn setTitle:@"load 2 -> 1" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onLoad3:) forControlEvents:(UIControlEventTouchUpInside)];
    borderControl(btn);
    [self.view addSubview:btn];

    
    btn = [[UIButton alloc] initWithFrame:(CGRect){{30, 250}, {100, 44}}];
    [btn setTitle:@"clear" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [btn addTarget:self action:@selector(onTap2:) forControlEvents:(UIControlEventTouchUpInside)];
    borderControl(btn);
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:(CGRect){{150, 150}, {100, 44}}];
    [btn setTitle:@"placeholder" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [btn addTarget:self action:@selector(onTap3:) forControlEvents:(UIControlEventTouchUpInside)];
    borderControl(btn);
    [self.view addSubview:btn];
}

- (void)onLoad1:(id)sender {
    [iv loadImageFromUrl:@"http://dreamatico.com/data_images/girl/girl-8.jpg"];
     
//                   https://my.platformphoenix.com/photo/show/id/d02ff57ebf7a4679be75ea53e433d3b9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6IiIsInVwZGF0ZWRPbiI6IjAwMDAtMDAtMDAgMDA6MDA6MDAifQ%3D%3D"];
}

- (void)onLoad2:(id)sender {
    [iv loadImageFromUrl:@"https://my.platformphoenix.com/photo/show/id/d02ff57ebf7a4679be75ea53e433d3b9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6IiIsInVwZGF0ZWRPbiI6IjAwMDAtMDAtMDAgMDA6MDA6MDAifQ%3D%3D"];
}

- (void)onLoad3:(id)sender {
    [iv loadImageFromUrl:@"http://dreamatico.com/data_images/girl/girl-8.jpg"];
}

- (void)onTap2:(id)sender {
    iv.image = nil;
}

- (void)onTap3:(id)sender {
//    UILabel *placeholder = [[UILabel alloc] init];
//    placeholder.textColor = [UIColor redColor];
//    placeholder.text = @"No image";
//    placeholder.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//    placeholder.contentMode = UIViewContentModeCenter;
//    placeholder.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    
//    iv.placeholderView = placeholder;
    
//    UIImageView *p = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"private_photo_small"]];
//    iv.placeholderView = p;
    
    UIView *p = [[UIView alloc] initWithFrame:(CGRect){{0, 0}, {100, 100}}];
    UIImage *img = [UIImage imageNamed:@"private_photo_small"];
//    p.layer.frame = (CGRect){{0, 0}, img.size};
    p.layer.contents = (id)img.CGImage;
    iv.placeholderView = p;
}

@end
