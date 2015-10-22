//
//  ViewController.m
//  pixelate
//
//  Created by Zinets Victor on 7/17/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "MosaicView.h"

@interface ViewController () {
    UIImageView *iv;
    
    unsigned char *data;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    iv = [[UIImageView alloc] initWithFrame:(CGRect){{30, 30}, {320-60, 320-60}}];
    iv.image = [UIImage imageNamed:@"beautiful.png"];
    [self.view addSubview:iv];
    
    MosaicView *mv = [[MosaicView alloc] initWithFrame:(CGRect){{30, 300}, {320-60, 320-60}}];
    mv.flag = 4;
    [self.view addSubview:mv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// вышел за пределы - сам дурак
- (UIColor *)colorForPixel:(int)x :(int)y :(int)w :(int)h {
    UIColor *res = nil;
    
    int offset = (y * w + x) * 4;

    int alpha =  data[offset++];
    int red = data[offset++];
    int green = data[offset++];
    int blue = data[offset];

    res = [[UIColor alloc] initWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:(alpha / 255.0f)];
    
    return res;
}

- (unsigned char *)getData:(UIImage *)image :(int)w :(int)h {
    unsigned char * ptr = nil;
    
    CGSize sz = (CGSize){w, h};
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [image drawInRect:(CGRect){CGPointZero, sz}];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRef clr = CGColorSpaceCreateDeviceRGB();
    ptr = malloc(w * h * 4);
    
    CGContextRef context = CGBitmapContextCreate (ptr, w, h, 8, w * 4, clr, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, (CGRect){CGPointZero, sz}, resizedImage.CGImage);
    
    CGContextRelease(context);
    CGColorSpaceRelease(clr);
    
    return ptr;
}

@end
