//
//  ViewController.m
//  zoom
//
//  Created by Zinets Victor on 5/15/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "PhotoView.h"

@interface ViewController () {
    PhotoView * photoView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];

    photoView = [[PhotoView alloc] initWithFrame:self.view.bounds];
    photoView.minimumZoomScale = 0.5;
    photoView.maximumZoomScale = 2;
    photoView.zoomEnabled = YES;
    photoView.alignToTop = YES;
    photoView.delegate = photoView;
    [self.view addSubview:photoView];
    
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{0, 30}, {100, 44}};
    [btn setTitle:@"load 1" forState:(UIControlStateNormal)];
    btn.tag = 0;
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{110, 30}, {100, 44}};
    [btn setTitle:@"load 2" forState:(UIControlStateNormal)];
    btn.tag = 1;
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{210, 30}, {100, 44}};
    [btn setTitle:@"load 3" forState:(UIControlStateNormal)];
    btn.tag = 2;
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{60, 130}, {160, 44}};
    [btn setTitle:@"zoom enabled" forState:(UIControlStateNormal)];
    [btn setTitle:@"zoom disabled" forState:(UIControlStateSelected)];

    [btn addTarget:self action:@selector(onZoom:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

-(void)onTap:(UIButton *)sender {
    NSArray *arr = @[@"portrait.jpg", @"land.jpg", @"small.jpg"];
    
    UIImageView * photo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arr[sender.tag]]];
    photoView.viewToZoom = photo;
    
}

-(void)onZoom:(UIButton *)sender {
    photoView.zoomEnabled = !photoView.zoomEnabled;
    sender.selected = !photoView.zoomEnabled;
}


@end
