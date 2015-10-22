//
//  ViewController.m
//  zoomScroller
//
//  Created by Zinets Victor on 7/27/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "ImageScrollView2.h"
#import "UIColor+MUIColor.h"
#import "UIView+Geometry.h"

@interface ViewController () <ImageScrollViewProto> {
    ImageScrollView2 *scroller;
    UIButton *fsBtn, *zoomBtn;
    ImageScrollViewMode mode;
}

@end

@implementation ViewController

-(UIView *)lockView {
    UIView *lock1 = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    lock1.userInteractionEnabled = NO;
    lock1.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    
    UIView *textBg = [UIView new];
    textBg.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4];
    textBg.width = lock1.width - 64;
    textBg.height = 65;
    textBg.centerX = lock1.width/2;
    textBg.centerY = lock1.height/3;
    textBg.clipsToBounds = YES;
    textBg.layer.cornerRadius = textBg.height/2;
    [lock1 addSubview:textBg];
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"USER_PROFILE_TAP_HERE";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 2;
    [label sizeToFit];
    label.center = textBg.center;
    [lock1 addSubview:label];
    
    return lock1;
}

-(UIView *)lockView2 {
    UIView *lock1 = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    lock1.autoresizingMask = UIViewAutoresizingFlexibleSize;
    lock1.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.6];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-lock"]];
    logo.top = 100 + 20; // сдвиг 20 нужен из-за "эластичности" профиля
    logo.centerX = lock1.width / 2;
    [lock1 addSubview:logo];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:(CGRect){{20, 150 + 20}, {lock1.width - 40, 17}}];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"Request sent";
    [lock1 addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:(CGRect){{20, 177 + 20}, {lock1.width - 40, 40}}];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 0;
    
    lbl.text = @"Please wait or check out your publick photos meanwhile";
    [lock1 addSubview:lbl];
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"Request to view" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
    btn.size = (CGSize){100, 44};
    btn.top = 210 + 20;
    btn.centerX = lock1.width / 2;
    [btn addTarget:self action:@selector(onTap1:) forControlEvents:(UIControlEventTouchUpInside)];
    [lock1 addSubview:btn];
    
    return lock1;
}

- (void)onTap1:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UrlImageView setAppMarkerForType:ImageRequestModeCasualDating];

    CGRect frm = self.view.bounds;
    frm.size.height -= 200;
    scroller = [[ImageScrollView2 alloc] initWithFrame:frm];
    scroller.backgroundColor = [UIColor colorWithHex:0x821099];
    scroller.pullDownOffset = 200;
    
    UIImageView *_placeholderView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _placeholderView.image = [UIImage imageNamed:@"placeholder"];
    _placeholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _placeholderView.contentMode = UIViewContentModeTop;//Center;
    _placeholderView.hidden = NO;    
    scroller.placeholderView = _placeholderView;

    scroller.lockView = [self lockView2];
    //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
    scroller.lockView.contentMode = UIViewContentModeCenter;
    scroller.actionDelegate = self;
    
    [self.view addSubview:scroller];
    
    // ------------------------------------ load
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{4, 20}, {80, 30}};
    btn.tag = 1;
    btn.backgroundColor = [UIColor colorWithHex:0x1199dd];
    [btn setTitle:@"load 1" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{4, 60}, {80, 30}};
    btn.tag = 2;
    btn.backgroundColor = [UIColor colorWithHex:0x1199dd];
    [btn setTitle:@"load 2" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{4, 100}, {80, 30}};
    btn.tag = 3;
    btn.backgroundColor = [UIColor colorWithHex:0x1199dd];
    [btn setTitle:@"load 3" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{4, 140}, {80, 30}};
    btn.tag = 4;
    btn.backgroundColor = [UIColor colorWithHex:0x1199dd];
    [btn setTitle:@"load 4" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{4, 180}, {80, 30}};
    btn.tag = 5;
    btn.backgroundColor = [UIColor colorWithHex:0x1199dd];
    [btn setTitle:@"load 5" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{176, 20}, {80, 44}};
    btn.tag = 13;
    btn.backgroundColor = [UIColor colorWithHex:0xd199dd];
    [btn setTitle:@"unload" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    // ------------------------------------ zoom
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{4, 370}, {80, 44}};
    [btn setBackgroundColor:[UIColor colorWithHex:0x871261]];
    [btn setTitle:@"zoom off" forState:(UIControlStateNormal)];
    [btn setTitle:@"zoom on" forState:(UIControlStateSelected)];
    [btn addTarget:self action:@selector(onZoomEnable:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.selected = scroller.zoomEnabled;
    [self.view addSubview:btn];
    
    zoomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    zoomBtn.frame = (CGRect){{4, 420}, {80, 44}};
    [zoomBtn setBackgroundColor:[UIColor colorWithHex:0x12a461]];
    [zoomBtn setTitle:@"zoom fit" forState:(UIControlStateNormal)];
    [zoomBtn setTitle:@"zoom max" forState:(UIControlStateSelected)];
    [zoomBtn addTarget:self action:@selector(onZoomChange:) forControlEvents:(UIControlEventTouchUpInside)];
    zoomBtn.selected = NO;
    [self.view addSubview:zoomBtn];
    
    // ------------------------------------ FULL SCREEN
    fsBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    fsBtn.frame = (CGRect){{4, 470}, {80, 44}};
    [fsBtn setBackgroundColor:[UIColor colorWithHex:0x718261]];
    [fsBtn setTitle:@"full off" forState:(UIControlStateNormal)];
    [fsBtn setTitle:@"full on" forState:(UIControlStateSelected)];
    [fsBtn addTarget:self action:@selector(onFullScr:) forControlEvents:(UIControlEventTouchUpInside)];
    fsBtn.selected = NO;
    [self.view addSubview:fsBtn];
    
    // ------------------------------------ blur
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{4, 470 + 50}, {80, 44}};
    btn.backgroundColor = [UIColor colorWithHex:0x192dd2];
    [btn setTitle:@"blur off" forState:(UIControlStateNormal)];
    [btn setTitle:@"blur on" forState:(UIControlStateSelected)];
    [btn addTarget:self action:@selector(onBlur:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    // ------------------------------------ modes
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{216, 470 + 50}, {100, 44}};
    btn.backgroundColor = [UIColor colorWithHex:0x192dd2];
    [btn setTitle:@"fit" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onMode:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

-(void)onMode:(UIButton *)sender {
    mode++;
    mode %= 4;
    
    scroller.zoomMode = mode;
    switch (mode) {
        case ImageScrollViewModeVerticalFit:
            [sender setTitle:@"vert. fit" forState:(UIControlStateNormal)];
            break;
        case ImageScrollViewModeFit:
            [sender setTitle:@"fit" forState:(UIControlStateNormal)];
            break;
        case ImageScrollViewModeTopFit:
            [sender setTitle:@"top fit" forState:(UIControlStateNormal)];
            break;
        case ImageScrollViewModeFill:
            [sender setTitle:@"fill" forState:(UIControlStateNormal)];
            break;
        default:
            break;
    }
}

-(void)onBlur:(UIButton *)sender {
    sender.selected = !sender.selected;
    scroller.blurredContent = sender.selected;
}

- (void)onTap:(UIButton *)sender {
    if (sender.tag == 1) {
        scroller.imageUrl = @"http://cdn.wdrimg.com/photo/show/id/ee52a891c3ec460085dd32255de0acd8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6IiIsInVwZGF0ZWRPbiI6IjAwMDAtMDAtMDAgMDA6MDA6MDAifQ%3D%3D";
    } else if (sender.tag == 2) {
        scroller.imageUrl = @"http://cdn.wdrimg.com/photo/show/id/90cddb4c3f294b7f9df79e3d720bee1d?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6IiIsInVwZGF0ZWRPbiI6IjIwMTQtMTAtMDkgMDA6MjU6NDUifQ%3D%3D";
    } else if (sender.tag == 3) {
        scroller.imageUrl = @"http://cdn.wdrimg.com/photo/show/id/87b2c6f7adbf454aa6753fd41d5f5ef0?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6IiIsInVwZGF0ZWRPbiI6IjAwMDAtMDAtMDAgMDA6MDA6MDAifQ%3D%3D";
    } else if (sender.tag == 4) {
        scroller.imageUrl = @"http://cdn.wdrimg.com/photo/show/id/b74747c150c54e4e8f2e58aecf5a29df?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6IiIsInVwZGF0ZWRPbiI6IjIwMTUtMDItMTQgMTk6MzE6MTcifQ%3D%3D";
    } else if (sender.tag == 5) {
        scroller.imageUrl = @"http://cdn.wdrimg.com/photo/show/id/bd922c3b0c7743248ca4191ac78ef7a5?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6IiIsInVwZGF0ZWRPbiI6IjIwMTQtMDgtMTMgMDk6MjU6MTEifQ%3D%3D";
    } else if (sender.tag == 13) {
        scroller.imageUrl = nil;
    }
}

- (void)onZoomEnable:(UIButton *)sender {
    sender.selected = !sender.selected;
    scroller.zoomEnabled = sender.selected;
}

- (void)onZoomChange:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [scroller setZoomScale:scroller.maximumZoomScale animated:YES];
    } else {
        [scroller setZoomScale:scroller.minimumZoomScale animated:YES];
    }
}

- (void)onFullScr:(UIButton *)sender {
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.25 animations:^{
        if (sender.selected) {
            scroller.frame = self.view.bounds;
            scroller.zoomMode = ImageScrollViewModeFit;
        } else {
            CGRect frm = self.view.bounds;
            frm.size.height -= 200;
            scroller.frame = frm;
            scroller.zoomMode = ImageScrollViewModeVerticalFit;
        }
    }];
}

#pragma mark - 

-(void)scrollerDetectedTap:(ImageScrollView2 *)sender {
    [self onFullScr:fsBtn];
}

-(void)scrollerDetectedDblTap:(ImageScrollView2 *)sender {
    [self onZoomChange:zoomBtn];
}

//-(void)scrollerDetectedPullDown:(ImageScrollView2 *)sender {
//    [self onFullScr:fsBtn];
//}

@end
