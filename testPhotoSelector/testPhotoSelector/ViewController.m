//
//  ViewController.m
//  testPhotoSelector
//
//  Created by Zinets Victor on 9/27/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "ImageSourceSelector.h"
#import "ImageSelectorViewController.h"

@interface ViewController () <ImageSourceSelectorDelegate, ImageSelectorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)onUpload:(id)sender {
    ImageSourceSelector *s = [ImageSourceSelector new];
    s.cancelButtonTitle = @"Cancel";
    s.otherButtonTitles = @[@"CAMERA", @"LIBRARY", @"PHOTOS_ALBUM", @"FACEBOOK_PHOTOS", @"INSTAGRAM_PHOTOS"];
    s.delegate = self;
    [s showInView:self.view];

//    ImageSelectorViewController *ctrl = [ImageSelectorViewController new];
//    [self addChildViewController:ctrl];
//    [self.view addSubview:ctrl.view];
//    [ctrl didMoveToParentViewController:self];
//    
//    ctrl.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        ctrl.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
//    } completion:^(BOOL finished) {
//        if (finished) {
//        }
//    }];

}

- (IBAction)onSelect2:(id)sender {
    ImageSelectorViewController *ctrl = [ImageSelectorViewController new];
    ctrl.delegate = self;
    
    [self addChildViewController:ctrl];
    [self.view addSubview:ctrl.view];
    [ctrl didMoveToParentViewController:self];


    
    ctrl.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        ctrl.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    } completion:^(BOOL finished) {
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageSourceSelector:(ImageSourceSelector *)imageSourceSelector clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index %@", @(buttonIndex));
}

- (void)imageSourceSelector:(ImageSourceSelector *)imageSourceSelector imageSelected:(UIImage *)image {
    NSLog(@"%@", image);
}

- (void)imageSourceSelectorCameraClicked:(ImageSourceSelector *)imageSourceSelector {
    NSLog(@"camera clicked");
}

#pragma mark - image selector as controller

- (BOOL)imageSelector:(id)sender supportsSourcetype:(ImageSourceType)sourceType {
    return
    sourceType == ImageSourceTypeLive ||
    sourceType == ImageSourceTypeCamera ||
    sourceType == ImageSourceTypeLibrary ||
    sourceType == ImageSourceTypeAlbums;
}

- (NSString *)imageSelector:(id)sender titleForSourceType:(ImageSourceType)sourceType {
    switch (sourceType) {
        case ImageSourceTypeLive:
            return @"Live output"; // хотя смысла и нет
        case ImageSourceTypeCamera:
            return @"Camera";
        case ImageSourceTypeLibrary:
            return @"Library";
        case ImageSourceTypeAlbums:
            return @"Albums";
        default:
            return nil;
    }
}

- (UIImage *)imageSelector:(id)sender iconForSourceType:(ImageSourceType)sourceType {
    NSString *fn = nil;
    switch (sourceType) {
        case ImageSourceTypeCamera:
            fn = @"action-sheet-camera";
            break;
        case ImageSourceTypeAlbums:
            fn = @"action-sheet-gallery";
            break;            
        default:
            break;
    }
    return fn ? [UIImage imageNamed:fn] : nil;
}

@end
