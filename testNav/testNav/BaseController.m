//
//  BaseController.m
//  testNav
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *backToTopButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.backButton];
    [self.view addSubview:self.backToTopButton];
}

#pragma mark - getters

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){{55, 20}, {self.view.bounds.size.width - 55 - 20, 40}}];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _backButton.frame = (CGRect){{15, 20}, {40, 40}};
        _backButton.backgroundColor = [UIColor darkGrayColor];
        [_backButton setTitle:@"<" forState:(UIControlStateNormal)];
        
        [_backButton addTarget:self action:@selector(onBackButtonTap:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backButton;
}

-(UIButton *)backToTopButton {
    if (!_backToTopButton) {
        _backToTopButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _backToTopButton.frame = (CGRect){{250, 20}, {40, 40}};
        _backToTopButton.backgroundColor = [UIColor darkGrayColor];
        [_backToTopButton setTitle:@"^" forState:(UIControlStateNormal)];
        
        [_backToTopButton addTarget:self action:@selector(onBackToTopButtonTap:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backToTopButton;
}

-(void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

#pragma mark - actions

- (void)onBackButtonTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBackToTopButtonTap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
