//
//  ImageSelectorViewController.m
//  testPhotoSelector
//
//  Created by Zinets Victor on 9/27/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ImageSelectorViewController.h"

@interface ImageSelectorViewController ()

@end

@implementation ImageSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor magentaColor];
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)onTapAction:(id)sender {
    NSLog(@"123");
}


@end
