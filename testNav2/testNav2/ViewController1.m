//
//  ViewController1.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController1.h"
#warning 
// это для теста онли!
#import "ControllerFactory.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    self.viewTitle = @"Я вьюконтроллер 1!";
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"Create instance of view controller #2" forState:(UIControlStateNormal)];
    btn.frame = (CGRect){{5, 100}, {310, 44}};
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UITextField *text = [[UITextField alloc] initWithFrame:(CGRect){{15, 150}, {290, 30}}];
    text.backgroundColor = [UIColor whiteColor];
    text.textColor = [UIColor blackColor];
    // просто чтобы увидеть реюзание контроллера$ глючит но пофиг
    [self.view addSubview:text];
}

- (void)onTap:(id)sender {
    [self.navigationController pushViewController:[ControllerFactory controllerByKind:(ControllerKind2)] animated:YES];
    
}

@end
