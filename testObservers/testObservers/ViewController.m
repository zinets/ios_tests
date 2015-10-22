//
//  ViewController.m
//  testObservers
//
//  Created by Zinetz Victor on 10.12.14.
//  Copyright (c) 2014 Cupid plc. All rights reserved.
//

#import "ViewController.h"
#import "BaseClass.h"

@interface ViewController ()
- (IBAction)onTap:(id)sender;

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

- (IBAction)onTap:(id)sender {
    BaseClass * class1 = [BaseClass new];
    [class1 doSomething];
    class1 = nil;
}

@end
