//
//  FlirtPhotoCropper.m
//
//  Created by Zinetz Victor on 01.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import "PhotoCropController.h"

@interface PhotoCropController () <UIScrollViewDelegate> {
    UIScrollView * _scroller;
    UIImageView * _iv;
}
@end

@implementation PhotoCropController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;

    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 51);
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:frame];
#warning localize me
    hintLabel.text = @"SCALE_CROP";
    hintLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.backgroundColor = [UIColor blackColor]; // был 040707
    [self.view addSubview:hintLabel];

    frame = CGRectMake(0, self.view.bounds.size.height - 90, self.view.bounds.size.width, 90);
    UIView *bottomToolbarBg = [[UIView alloc] initWithFrame:frame];
    bottomToolbarBg.backgroundColor = [UIColor blackColor]; // был 040707
    [self.view addSubview:bottomToolbarBg];
    
    UIButton * doneButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    doneButton.frame = (CGRect){{}, {70, 70}};
    doneButton.layer.cornerRadius = 35;
#warning localize me
    [doneButton setTitle:@"DONE" forState:(UIControlStateNormal)];
    [doneButton addTarget:self action:@selector(onDoneAction:) forControlEvents:(UIControlEventTouchUpInside)];
    doneButton.center = CGPointMake(bottomToolbarBg.bounds.size.width / 2, bottomToolbarBg.bounds.size.height / 2);
    [bottomToolbarBg addSubview:doneButton];

    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
#warning localize me!
    [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [backButton setTitle:@"Back" forState:(UIControlStateNormal)];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(onBackAction) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.center = (CGPoint){15 + backButton.bounds.size.width / 2, bottomToolbarBg.bounds.size.height / 2};
    [bottomToolbarBg addSubview:backButton];

    frame = CGRectMake(0, hintLabel.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - hintLabel.bounds.size.height - bottomToolbarBg.bounds.size.height);
    _scroller = [[UIScrollView alloc] initWithFrame:frame];
    _scroller.maximumZoomScale = 2.5;
    _scroller.delegate = self;
    [self.view insertSubview:_scroller atIndex:0];

    _iv = [[UIImageView alloc] initWithFrame:_scroller.bounds];
    [_scroller addSubview:_iv];

    [self loadImageToCrop];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - actions

-(void)onDoneAction:(id)sender {
    if (self.completionBlock) {
        UIGraphicsBeginImageContextWithOptions(_scroller.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextConcatCTM(ctx, CGAffineTransformMakeTranslation(-_scroller.contentOffset.x, -_scroller.contentOffset.y));
        [_scroller.layer renderInContext:ctx];
        UIImage * cropped = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.completionBlock (cropped);
    }
}

- (void)onBackAction
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - set/getters
- (void)loadImageToCrop
{
    if(!_imageToCrop)
        return;

    _iv.image = _imageToCrop;
    [_iv sizeToFit];

    _scroller.contentSize = _imageToCrop.size;
    CGPoint c = (CGPoint){(_iv.bounds.size.width - _scroller.bounds.size.width) / 2, (_iv.bounds.size.height - _scroller.bounds.size.height) / 2};
    _scroller.contentOffset = c;

    CGSize boundsSize = _scroller.bounds.size;
    CGFloat xScale = boundsSize.width  / _iv.frame.size.width;
    CGFloat yScale = boundsSize.height / _iv.frame.size.height;
    CGFloat minScale = MAX(xScale, yScale);

    if (xScale < 1 || yScale < 1) {
        minScale = MIN(1, minScale);
    }
    _scroller.minimumZoomScale = minScale;
    _scroller.zoomScale = minScale;
}
#pragma mark - scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _iv;
}

@end
