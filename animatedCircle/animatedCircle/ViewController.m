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
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"anim shape" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(onTapAnim:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = (CGRect){{220, 150}, {80, 40}};
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"anim 2" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(onTapAnim2:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = (CGRect){{220, 200}, {80, 40}};
    [self.view addSubview:btn];

}

- (void)onTap1:(id)sender {
    [self addShape1];
}

- (void)onTap2:(id)sender {
    [self addShape3];
}

- (CGPathRef)currentPath:(CGFloat)a {
    UIBezierPath *path = nil; {
        NSMutableArray *points = [NSMutableArray array];
        CGFloat angle = 0;
        CGPoint center = CGRectGetCenter(layer.bounds);
        const int count = 12;
        CGFloat step = 2 * M_PI / count;
        for (int x = 0; x < count; x++) {
            CGFloat len = 70;
            if (x == 0) {
                len = 85;
            }
            CGPoint pt = (CGPoint){center.x + len * sin(angle), center.y + len * cos(angle)};
            [points addObject:[NSValue valueWithCGPoint:pt]];
            
            angle += step;
        }
        
        path = [UIBezierPath interpolateCGPointsWithCatmullRom:points closed:YES alpha:1];
    }
    return path.CGPath;
}

- (void)addShape3 {
    [site removeFromSuperview];
    
    site = [[UIView alloc] initWithFrame:(CGRect){{20, 50}, {150, 150}}];
    site.backgroundColor = [UIColor grayColor];
    
    UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [site addGestureRecognizer:g];
    
    [self.view addSubview:site];
    
    layer = [CAShapeLayer layer];
    layer.frame = site.bounds;
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    [site.layer addSublayer:layer];
    
    UIBezierPath *path = nil; {
        NSMutableArray *points = [NSMutableArray array];
        CGFloat angle = 0;
        CGPoint center = CGRectGetCenter(layer.bounds);
        const int count = 18;
        CGFloat step = 2 * M_PI / count;
        for (int x = 0; x < count; x++) {
            CGFloat len = x % 3 == 0 ? 70 : 85;
            CGPoint pt = (CGPoint){center.x + len * sin(angle), center.y + len * cos(angle)};
            [points addObject:[NSValue valueWithCGPoint:pt]];
            
            angle += step;
        }
        
        path = [UIBezierPath interpolateCGPointsWithCatmullRom:points closed:YES alpha:1];
    }
    layer.path = path.CGPath;
}

- (void)onTapAnim:(id)sender {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    UIBezierPath *path = nil; {
        NSMutableArray *points = [NSMutableArray array];
        CGFloat angle = 0;
        CGPoint center = CGRectGetCenter(layer.bounds);
        const int count = 8;
        CGFloat step = 2 * M_PI / count;
        for (int x = 0; x < count; x++) {
            CGFloat len = x == 6 ? 85 : 70;
            CGPoint pt = (CGPoint){center.x + len * sin(angle), center.y + len * cos(angle)};
            [points addObject:[NSValue valueWithCGPoint:pt]];
            
            angle += step;
        }
        
        path = [UIBezierPath interpolateCGPointsWithCatmullRom:points closed:YES alpha:1];
    }
    anim.toValue = (id)path.CGPath;
    anim.duration = 1.5;
    anim.removedOnCompletion = NO;
    
    [layer removeAllAnimations];
    [layer addAnimation:anim forKey:@""];
    layer.path = path.CGPath;
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

#pragma mark - gesture

- (void)onPan:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateChanged: {
            CGPoint offset = [sender translationInView:site];
            offset.x /= 2;
            offset.y /= 2;
            CGFloat angle = atan(offset.x / offset.y);

            layer.path = [self currentPath:angle];
            site.transform = CGAffineTransformMakeRotation(angle);
        } break;
        default:
            break;
    }
}

- (void)onTapAnim2:(id)sender {
    [site removeFromSuperview];
    
    site = [[UIView alloc] initWithFrame:(CGRect){{20, 50}, {150, 150}}];
    site.backgroundColor = [UIColor grayColor];
    [self.view addSubview:site];

    layer = [CAShapeLayer layer];
    layer.frame = site.bounds;
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    
    UIBezierPath *path = nil; {
        NSMutableArray *points = [NSMutableArray array];
        CGFloat angle = 0;
        CGPoint center = CGRectGetCenter(layer.bounds);
        const int count = 8;
        CGFloat step = 2 * M_PI / count;
        for (int x = 0; x < count; x++) {
            CGFloat len = 40;
            CGPoint pt = (CGPoint){center.x + len * sin(angle), center.y + len * cos(angle)};
            [points addObject:[NSValue valueWithCGPoint:pt]];
            
            angle += step;
        }
        
        path = [UIBezierPath interpolateCGPointsWithCatmullRom:points closed:YES alpha:1];
    }
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
//    layer.path = path.CGPath;
    anim.fromValue = (id)path.CGPath;
    [site.layer addSublayer:layer];
    
    {
        NSMutableArray *points = [NSMutableArray array];
        CGFloat angle = 0;
        CGPoint center = CGRectGetCenter(layer.bounds);
        const int count = 8;
        CGFloat step = 2 * M_PI / count;
        for (int x = 0; x < count; x++) {
            CGFloat len = x == 6 ? 85 : 40;
            CGPoint pt = (CGPoint){center.x + len * sin(angle), center.y + len * cos(angle)};
            [points addObject:[NSValue valueWithCGPoint:pt]];
            
            angle += step;
        }
        
        path = [UIBezierPath interpolateCGPointsWithCatmullRom:points closed:YES alpha:1];
    }
    anim.toValue = (id)path.CGPath;
    anim.duration = 0.25;
    anim.removedOnCompletion = NO;

    layer.path = path.CGPath;
    [layer addAnimation:anim forKey:@"1"];
    
}

@end
