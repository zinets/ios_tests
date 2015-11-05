//
//  ViewController.m
//  colors
//
//  Created by Zinets Victor on 10/20/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "ColorBox.h"
#include "core.h"

#define LEDS_COUNT 30

@interface ViewController () {
    NSArray <ColorBox *> *boxes;
    UIScrollView *scroller;
    NSTimer *timer;
    
    HSBColor *leds;
}
@property (weak, nonatomic) IBOutlet ColorBox *testBox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroller.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scroller];
    
    leds = init_leds();

    NSMutableArray *arr = [NSMutableArray array];
    for (int x = 0; x < LEDS_COUNT; x++) {
        ColorBox *box = [ColorBox new];
        box.size = (CGSize){30, 15};
        [box setColor:leds[x]];
        [arr addObject:box];
    }
    boxes = [NSArray arrayWithArray:arr];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{70, 10}, {100, 40}};
    btn.backgroundColor = [UIColor colorWithHex:random()];
    [btn setTitle:@"button 1" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onButton1Tap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    self.testBox.backgroundColor = [UIColor redColor];
    self.testBox.layer.borderColor = [UIColor greenColor].CGColor;
    self.testBox.layer.borderWidth = 2;
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{70, 70}, {100, 40}};
    btn.backgroundColor = [UIColor colorWithHex:random()];
    [btn setTitle:@"start cycle" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onButton2Tap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __block CGPoint pt = (CGPoint){10, 10};
    [boxes enumerateObjectsUsingBlock:^(ColorBox * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.origin = pt;
        pt.y += obj.height + 2;
        
        [scroller addSubview:obj];
    }];
    CGSize sz = (CGSize){self.view.width, pt.y};
    scroller.contentSize = sz;
    
    [self.view sendSubviewToBack:scroller];
}

#pragma mark - actions

- (void)onButton1Tap:(id)sender {
    int step = 360 / boxes.count;
    int h = 0;
    for (ColorBox *box in boxes) {
//        box.hue = h;
        box.brightness -= 5;
        h += step;
    }
}

- (void)onButton2Tap:(UIButton *)sender {
    if (timer) {
        [timer invalidate];
        timer = nil;
        [sender setTitle:@"Start cycle" forState:(UIControlStateNormal)];
    } else {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 / 15.0 target:self selector:@selector(onTimer:) userInfo:Nil repeats:YES];
        [sender setTitle:@"Stop cycle" forState:(UIControlStateNormal)];
    }
}


- (IBAction)onH:(UISlider *)sender {
    self.testBox.hue = (int)(sender.value * 255);
}

- (IBAction)onB:(UISlider *)sender {
    self.testBox.brightness = (int)(sender.value * 255);
}

-(IBAction)onS:(UISlider *)sender {
    self.testBox.saturation = (int)(sender.value * 255);
}

- (void)onTimer:(id)sender {
//    func1();
    func12();
    
    
    for (int x = 0; x < LEDS_COUNT; x++) {
        ColorBox *box = boxes[x];
        [box setColor:leds[x]];
    }
}

@end
