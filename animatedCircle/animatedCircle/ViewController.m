//
//  ViewController.m
//  animatedCircle
//
//  Created by Zinets Victor on 10/29/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Geometry.h"
#import "UIBezierPath+Interpolation.h"

@interface ViewController () {
    UIView *site;
    CAShapeLayer *layer;
}

@end

CGFloat len2 () {
    CGFloat res = arc4random() % 50;
    
    return 25 + res;
}

#define M_PI_6 0.523598775598299

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"shape 1" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(onTap1:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = (CGRect){{220, 50}, {80, 40}};
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"shape 2" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(onTap2:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = (CGRect){{220, 100}, {80, 40}};
    [self.view addSubview:btn];
}

- (void)onTap1:(id)sender {
    [self addShape1];
}

- (void)onTap2:(id)sender {
    [self addShape2];
}


#pragma mark - draw

- (void)addShape2 {
    [site removeFromSuperview];
    
    site = [[UIView alloc] initWithFrame:(CGRect){{20, 50}, {150, 150}}];
    site.backgroundColor = [UIColor grayColor];
    [self.view addSubview:site];
    
    layer = [CAShapeLayer layer];
    layer.frame = site.bounds;
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    [site.layer addSublayer:layer];
    
    UIBezierPath *path = nil; {
        NSMutableArray *points = [NSMutableArray array];
        CGFloat angle = 0;
        CGPoint center = CGRectGetCenter(layer.bounds);
        for (int x = 0; x < 8; x++) {
            CGPoint pt = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
            [points addObject:[NSValue valueWithCGPoint:pt]];
            
            angle += M_PI_4;
        }
        
//        path = [UIBezierPath interpolateCGPointsWithHermite:points closed:YES];
        path = [UIBezierPath interpolateCGPointsWithCatmullRom:points closed:YES alpha:1];
//        layer.path = path.CGPath;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        anim.duration = 5;
        anim.fromValue = (id)path.CGPath;
        
        for (int x = 0; x < 8; x++) {
            CGPoint pt = (CGPoint){center.x + len2() * sin(angle), center.y + len2() * cos(angle)};
            [points addObject:[NSValue valueWithCGPoint:pt]];
            
            angle += M_PI_4;
        }
        
        path = [UIBezierPath interpolateCGPointsWithCatmullRom:points closed:YES alpha:1];
        anim.toValue = (id)path.CGPath;
        anim.removedOnCompletion = NO;
        
        [layer addAnimation:anim forKey:@"morph"];
    }
}

- (void)addShape1 {

    [site removeFromSuperview];
    
    site = [[UIView alloc] initWithFrame:(CGRect){{20, 50}, {150, 150}}];
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
