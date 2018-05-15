//
//  ViewController.m
//  testHexProgress
//
//  Created by Victor Zinets on 5/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "HexView.h"

@interface ViewController ()
@property (nonatomic, strong) HexView *hexView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)addView:(id)sender {
    self.hexView = [[HexView alloc] initWithFrame:(CGRect){30, 120, 120, 120}];
    self.hexView.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:self.hexView];
}

- (IBAction)incProgress:(id)sender {
    self.hexView.progress += 0.1;
}

- (IBAction)decProgress:(id)sender {
    self.hexView.progress -= 0.1;
}

@end
