//
//  ViewController.m
//  croppingTest
//
//  Created by Zinetz Victor on 17.01.13.
//  Copyright (c) 2013 Zinetz Victor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.idImageView.image = [UIImage imageNamed:@"test"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect {

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect( currentContext, clippedRect);
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 rect.origin.y * -1,
                                 imageToCrop.size.width,
                                 imageToCrop.size.height);

    CGContextTranslateCTM(currentContext, 0.0, rect.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cropped;
}

- (UIEdgeInsets)offsets:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    int leftOffset = 0, rightOffset = 0, topOffset = 0, bottomOffset = 0;
    
    int * ptr = (int *)rawData;
    while (leftOffset < width && *ptr == 0) {
        leftOffset++;
        ptr++;
    }
    rightOffset = width - leftOffset;
    while (rightOffset >= 0 && *ptr != 0) {
        rightOffset--;
        ptr++;
    }
    
    ptr = (int *)rawData;
    while (topOffset < height && *ptr == 0) {
        topOffset++;
        ptr += width;
    }
    bottomOffset = height - topOffset;
    while (bottomOffset >= 0 && *ptr != 0) {
        bottomOffset--;
        ptr += width;
    }
   
    UIEdgeInsets res = UIEdgeInsetsMake(--topOffset, --leftOffset, --bottomOffset, --rightOffset);
    
    NSLog(@"%@", NSStringFromUIEdgeInsets(res));
    return res;
}

- (IBAction)onClick:(id)sender {
    UIImage * src = [UIImage imageNamed:@"test"];
    CGRect r = CGRectMake(1, 1, src.size.width - 2, src.size.height - 2);
    UIImage * dest = [self imageByCropping:src
                                    toRect:r];
    _idImageView.image = dest;
}

- (IBAction)onOffsetTest:(id)sender {
    UIImage * src = [UIImage imageNamed:@"test"];
    CGRect r = CGRectMake(1, 1, src.size.width - 2, src.size.height - 2);
    UIImage * dest = [self imageByCropping:src toRect:r];
    UIEdgeInsets i = [self offsets:src];
    dest = [dest resizableImageWithCapInsets:i resizingMode:UIImageResizingModeStretch];
    
    r = CGRectMake(0, 0, 200, 200);
    _idImageView.frame = r;
    _idImageView.contentMode = UIViewContentModeScaleToFill;
    _idImageView.image = dest;

}

@end
