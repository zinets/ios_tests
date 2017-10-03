//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PhotoCropController.h"
#import "UIColor+MUIColor.h"

@interface PhotoCropController ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *cropButton;
@property (nonatomic, strong) UIButton *doneButton;


@property (nonatomic, strong) UIImageView *previewView;
@end

@implementation PhotoCropController {

}

- (UIImageView *)previewView {
    if (!_previewView) {
        _previewView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _previewView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _previewView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _previewView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame = (CGRect){8, [UIScreen mainScreen].bounds.size.height - 8 - 72, 72, 72};
        [_doneButton setImage:[UIImage imageNamed:@"cameraDone"] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(onDoneTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = (CGRect){0, 20, 40, 40};
        [_backButton setImage:[UIImage imageNamed:@"cameraBack48"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onBackTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.frame = (CGRect){self.view.bounds.size.width - 40, 20, 40, 40};
        [_resetButton setImage:[UIImage imageNamed:@"cameraReset48"] forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(onResetTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UIButton *)cropButton {
    if (!_cropButton) {
        _cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cropButton.frame = (CGRect){self.view.bounds.size.width - 40, 20, 40, 40};
        [_cropButton setImage:[UIImage imageNamed:@"cameraCrop48"] forState:UIControlStateNormal];
        [_cropButton addTarget:self action:@selector(onCropTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cropButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xc1c1c1];
    self.navigationController.navigationBarHidden = YES;

    [self.view addSubview:self.previewView];

    [self.view addSubview:self.backButton];
    [self.view addSubview:self.resetButton];
    [self.view addSubview:self.cropButton];
    [self.view addSubview:self.doneButton];

    self.mode = PhotoCropperModePreview;
}

#pragma mark - actions

- (void)onBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onResetTap:(id)sender {

}

- (void)onCropTap:(id)sender {
    self.mode = PhotoCropperModeCrop;
}

- (void)onDoneTap:(id)sender {
    // todo
    self.mode = PhotoCropperModePreview;
}

- (void)setMode:(PhotoCropperMode)mode {
    _mode = mode;
    [UIView animateWithDuration:0.4 animations:^{
        switch (_mode) {
            case PhotoCropperModePreview:
                self.backButton.alpha = 1;
                self.cropButton.alpha = 1;
                self.resetButton.alpha = 0;
                self.doneButton.alpha = 0;

                self.previewView.transform = CGAffineTransformIdentity;

                break;
            case PhotoCropperModeCrop:
                self.backButton.alpha = 1;
                self.cropButton.alpha = 0;
                self.resetButton.alpha = 1;
                self.doneButton.alpha = 1;

                self.previewView.transform = CGAffineTransformMakeScale(0.8, 0.8);

                break;
        }
    }];
}

- (void)setImageToCrop:(UIImage *)imageToCrop {
    _imageToCrop = imageToCrop;
    self.previewView.image = _imageToCrop;
}

@end