//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PhotoCropController.h"
#import "UIColor+MUIColor.h"

@implementation PhotoCropController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xc1c1c1];
    self.navigationController.navigationBarHidden = YES;

    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = (CGRect){0, 20, 40, 40};
    [back setImage:[UIImage imageNamed:@"cameraBack48"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onBackTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

- (void)onBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end