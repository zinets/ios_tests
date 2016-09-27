//
//  ViewController.m
//  testPhotoSelector
//
//  Created by Zinets Victor on 9/27/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "ImageSourceSelector.h"

@interface ViewController ()

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
    
    [s showInView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
