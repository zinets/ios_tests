//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PhotoCropController.h"
#import "PhotoCropControl.h"
#import "UIColor+MUIColor.h"

@interface PhotoCropController ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *cropButton;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UIImageView *previewView;
@property (nonatomic, strong) PhotoCropControl *cropControl;

@end

@implementation PhotoCropController {

}

- (PhotoCropControl *)cropControl {
    if (!_cropControl) {
        _cropControl = [[PhotoCropControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cropControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _cropControl;
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
    [self.view addSubview:self.cropControl];

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
    [self.cropControl resetCrop];
}

- (void)onCropTap:(id)sender {
    self.mode = PhotoCropperModeCrop;
}

- (void)onDoneTap:(id)sender {
    self.mode = PhotoCropperModeCompleted;
}

- (void)setMode:(PhotoCropperMode)mode {
    _mode = mode;

    switch (_mode) {
        case PhotoCropperModePreview: {
            [UIView animateWithDuration:0.4 animations:^{
                self.backButton.alpha = 1;
                self.cropButton.alpha = 1;
                self.resetButton.alpha = 0;
                self.doneButton.alpha = 0;

                self.cropControl.alpha = 0;
                self.previewView.alpha = 1;
            }];
        } break;
        case PhotoCropperModeCrop: {
            [UIView animateWithDuration:0.4 animations:^{
                self.backButton.alpha = 1;
                self.cropButton.alpha = 0;
                self.resetButton.alpha = 1;
                self.doneButton.alpha = 1;

                CGSize sz = [self.cropControl setImageToCrop:self.imageToCrop].size;
                CGFloat scale = MAX(sz.width / self.view.bounds.size.width, sz.height / self.view.bounds.size.height);
                self.previewView.transform = CGAffineTransformMakeScale(scale, scale);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.cropControl.alpha = 1;
                    self.previewView.alpha = 0;
                }];
            }];
        } break;
        case PhotoCropperModeCompleted: {
            self.cropControl.croppedImage;

            self.cropControl.alpha = 0;
            self.previewView.alpha = 1;
            [UIView animateWithDuration:0.4 animations:^{
                self.previewView.transform = CGAffineTransformIdentity;
                self.mode = PhotoCropperModePreview;
            } completion:^(BOOL finished) {

            }];
        } break;
    }
}

- (void)setImageToCrop:(UIImage *)imageToCrop {
    _imageToCrop = imageToCrop;
    self.previewView.image = _imageToCrop;
}

@end