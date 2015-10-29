//
//  ViewController.m
//  animatedCircle
//
//  Created by Zinets Victor on 10/29/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Geometry.h"

@interface ViewController () {
    UIView *site;
    CAShapeLayer *layer;
}

@end

CGFloat len2 () {
    CGFloat res = arc4random() % 50;
    
    return 25 + res;
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#define M_PI_6 0.523598775598299
    
    site = [[UIView alloc] initWithFrame:(CGRect){{50, 50}, {150, 150}}];
    site.backgroundColor = [UIColor grayColor];
    [self.view addSubview:site];
    
    layer = [CAShapeLayer layer];
    layer.frame = site.bounds;
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPath]; {
        
        CGPoint center = CGRectGetCenter(layer.bounds);
        const CGFloat len = 70;
        CGPoint endPoint, cp1, cp2;
        CGFloat angle = 0;
        
        CGPoint beginPoint = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
        [path moveToPoint:beginPoint];

        angle += M_PI_6;
        cp1 = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
        angle += M_PI_6;
        cp2 = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};

        angle += M_PI_6;
        endPoint = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
//        [path addLineToPoint:endPoint];
//        [path addCurveToPoint:endPoint controlPoint1:cp1 controlPoint2:cp2];
        [path addQuadCurveToPoint:endPoint controlPoint:cp1];

        angle += M_PI_6;
        cp1 = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
        angle += M_PI_6;
        cp2 = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};

        angle += M_PI_6;
        endPoint = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
//        [path addLineToPoint:endPoint];
//        [path addCurveToPoint:endPoint controlPoint1:cp1 controlPoint2:cp2];
        [path addQuadCurveToPoint:endPoint controlPoint:cp1];

        angle += M_PI_6;
        cp1 = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
        angle += M_PI_6;
        cp2 = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};

        angle += M_PI_6;
        endPoint = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
//        [path addLineToPoint:endPoint];
//        [path addCurveToPoint:endPoint controlPoint1:cp1 controlPoint2:cp2];
        [path addQuadCurveToPoint:endPoint controlPoint:cp1];
        
        angle += M_PI_6;
        cp1 = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
        angle += M_PI_6;
        cp2 = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
        
        angle += M_PI_6;
        endPoint = beginPoint;//(CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};

//        [path addLineToPoint:endPoint];
//        [path addCurveToPoint:endPoint controlPoint1:cp1 controlPoint2:cp2];
        [path addQuadCurveToPoint:endPoint controlPoint:cp1];
    }
    layer.path = path.CGPath;

    
    [site.layer addSublayer:layer];
}

@end
