//
//  ViewController23.m
//  testConversations
//
//  Created by Zinets Viktor on 1/15/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "ViewController23.h"
#import "UIViewController+Keyboard.h"

@interface ViewController23 ()

@end

@implementation ViewController23

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerKeyboard];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unregisterKeyboard];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
