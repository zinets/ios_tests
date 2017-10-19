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
    PixelateLayer *layer1 = [[PixelateLayer alloc] init:ShapeSquare resolution:20 size:20 offset:0 alpha:0.8];
    PixelateLayer *layer2 = [[PixelateLayer alloc] init:ShapeCircle
                                             resolution:10
                                                   size:10
                                                 offset:0
                                                  alpha:1];
    PixelateLayer *layer3 = [[PixelateLayer alloc] init:ShapeDiamond resolution:20 size:40 offset:0 alpha:0.8];
    PixelateLayer *layer4 = [[PixelateLayer alloc] init:ShapeDiamond resolution:20 size:20 offset:10 alpha:0.8];

    UIImage *resImg = [Pixelator create:img layers:@[
//            [[PixelateLayer alloc] init:ShapeSquare resolution:32 size:32 offset:0 alpha:0],
//    [[PixelateLayer alloc] init:ShapeCircle resolution:32 size:26 offset:13 alpha:0],
//    [[PixelateLayer alloc] init:ShapeSquare resolution:32 size:18 offset:10 alpha:0],
            layer1,
            layer3,

//            layer2,
    ]];


    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){{20, 20}, {280, 200}}];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = resImg;
    [self.view addSubview:imageView];

    imageView = [[UIImageView alloc] initWithFrame:(CGRect){{20, 20 + 290}, {280, 200}}];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = img;
    [self.view addSubview:imageView];
}



@end