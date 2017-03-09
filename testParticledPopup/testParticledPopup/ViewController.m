//
//  ViewController.m
//  testParticledPopup
//
//  Created by Zinets Victor on 3/9/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "PopupWithParticles.h"

@interface ViewController ()

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
    PopupWithParticles *popup = [[PopupWithParticles alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:popup];
}

@end
