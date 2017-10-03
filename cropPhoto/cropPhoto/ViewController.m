//
//  ViewController.m
//  cropPhoto
//
//  Created by Zinets Viktor on 10/3/17.
//  Copyright © 2017 TogetherN. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCropController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loadPortrait:(id)sender {
    [self loadWithPhoto:[UIImage imageNamed:@"photo_p.jpg"]];
}

- (IBAction)loadLandscape:(id)sender {
    [self loadWithPhoto:[UIImage imageNamed:@"photo_l.jpg"]];
}

- (IBAction)loadSmall:(id)sender {
    [self loadWithPhoto:[UIImage imageNamed:@"photo_s.jpg"]];
}

- (void)loadWithPhoto:(UIImage *)photo {
    PhotoCropController *ctrl = [PhotoCropController new];
    ctrl.imageToCrop = photo;
    [self.navigationController pushViewController:ctrl animated:YES];




}

@end
