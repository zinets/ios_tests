//
//  ViewController.m
//  likepackProto
//
//  Created by Victor Zinets on 6/19/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "CountdownControl.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CountdownControl *counter;
@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onIncCounter:(id)sender {
    [self.counter test];
}

- (IBAction)reset:(id)sender {
    self.testView.transform = CGAffineTransformIdentity;
}
- (IBAction)move1:(id)sender {
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformRotate(t, M_PI_4);
    t = CGAffineTransformTranslate(t, 100, 0);
    
    self.testView.transform = t;
}

- (IBAction)move2:(id)sender {
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, 100, 0);
    t = CGAffineTransformRotate(t, M_PI_4);
    
    self.testView.transform = t;
}

@end
