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


@end
