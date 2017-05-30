//
//  ViewController.m
//  animatedShape
//
//  Created by Zinets Viktor on 5/24/17.
//  Copyright © 2017 Zinets Viktor. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedHren.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AnimatedHren *testHren;

@end

@implementation ViewController

- (IBAction)onTap:(id)sender {
    [self.testHren animate];
}

@end
