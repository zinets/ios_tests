//
//  ViewController.m
//  testPixelator
//
//  Created by Zinets Viktor on 9/28/17.
//  Copyright © 2017 TogetherN. All rights reserved.
//

#import "ViewController.h"
#import "Pixelator.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *img = [UIImage imageNamed:@"image.jpg"];
    PixelateLayer *layer1 = [[PixelateLayer alloc] init:ShapeSquare resolution:10 size:10 offset:0 alpha:0.6];
//    PixelateLayer *layer2 = [[PixelateLayer alloc] init:ShapeSquare resolution:20 size:10 offset:5 alpha:0.6];

    UIImage *resImg = [Pixelator create:img layers:@[layer1]];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){{20, 70}, {280, 280}}];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = resImg;
    [self.view addSubview:imageView];
}



@end