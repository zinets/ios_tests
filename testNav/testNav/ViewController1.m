//
//  ViewController1.m
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController1.h"
#import "defines.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    self.viewTitle = @"Я вьюконтроллер 1!\n(can pan me)";
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"Create instance of view controller #2" forState:(UIControlStateNormal)];
    btn.frame = (CGRect){{5, 100}, {310, 44}};
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    _titleLabel.userInteractionEnabled = YES;
    [_titleLabel addGestureRecognizer:pan];
}

- (void)onTap:(id)sender {
    [((NavViewController *)self.view.window.rootViewController) sender:self wantAddNewControllerByKind:(ControllerKind2)];
}

#pragma mark - gestures

- (void)onPan:(UIPanGestureRecognizer *)sender {
    CGPoint loc = [sender locationInView:self.view];
    static CGPoint startPt;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            startPt = loc;
            break;
        case UIGestureRecognizerStateChanged: {
            CGRect frm = self.view.frame;
            
            CGFloat y = loc.y - startPt.y;
            frm.origin.y += y;
            self.view.frame = frm;
        } break;
        case UIGestureRecognizerStateEnded: {
            CGPoint cp = self.view.frame.origin;
#warning 
            // тут по идее будет коммит/кансел интерактивного перехода
            if (cp.y < [UIScreen mainScreen].bounds.size.height / 2) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.frame = [UIScreen mainScreen].bounds;
                }];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } break;
        default:
            break;
    }
}

@end
