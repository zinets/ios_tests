//
//  ViewController.m
//  testFaceDetect
//
//  Created by Zinets Viktor on 5/5/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIView *faceFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.faceFrame = [UIView new];
    self.faceFrame.layer.borderWidth = 1;
    self.faceFrame.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.faceFrame];
}

- (IBAction)onTap:(id)sender {
    static int imageIndex = 0;
    NSArray *images = @[@"s1", @"s2", @"s3", @"s4"];

    UIImage *image = [UIImage imageNamed:images[imageIndex]];
    self.imageView.image = image;

    imageIndex = (imageIndex + 1) % images.count;
    NSLog(@"new index %@", @(imageIndex));

    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    CIContext *context = [CIContext context];
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyLow };
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:opts];

    NSArray <CIFaceFeature *> *features = [detector featuresInImage:ciImage options:opts];

    CGFloat k = MIN(image.size.width / self.imageView.bounds.size.width, image.size.height / self.imageView.bounds.size.height);
    self.faceFrame.hidden = YES;
    [features enumerateObjectsUsingBlock:^(CIFaceFeature *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@", NSStringFromCGRect(obj.bounds));
        CGRect frm = obj.bounds;
        frm.origin.x /= k;
        frm.origin.y /= k;
        frm.size.width /= k;
        frm.size.height /= k;

        self.faceFrame.hidden = NO;
        self.faceFrame.frame = frm; //obj.bounds;
    }];
}

@end
