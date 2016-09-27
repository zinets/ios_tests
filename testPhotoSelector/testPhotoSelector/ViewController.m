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

@interface ViewController () <ImageSourceSelectorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
//    ctrl.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        ctrl.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
//    } completion:^(BOOL finished) {
//        if (finished) {
//        }
//    }];

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

@end
