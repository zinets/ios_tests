//
//  CameraController.m
//  cameraTest
//
//  Created by Victor Zinets on 2/27/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "CameraController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *shutterButton;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;

// flash control
@property (weak, nonatomic) IBOutlet UIButton *flashOnButton;
@property (weak, nonatomic) IBOutlet UIButton *flashOffButton;
@property (weak, nonatomic) IBOutlet UIButton *flashAutoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFlashControllOffset;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;


@property (nonatomic) AVCaptureFlashMode flashMode;
@property (nonatomic) BOOL flashModeSelectorOpened;
@end

@implementation CameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flashMode = AVCaptureFlashModeAuto;
}

#pragma mark - setters

- (void)openFlashModeSelector {
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomFlashControllOffset.constant = 24;
        
        self.flashOnButton.alpha =
        self.flashOffButton.alpha =
        self.flashAutoButton.alpha = 1;
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.flashModeSelectorOpened = YES;
        self.tapRecognizer.enabled = YES;
    }];
}

-(void)setFlashMode:(AVCaptureFlashMode)flashMode {
    _flashMode = flashMode;
    [UIView animateWithDuration:0.4 animations:^{
        switch (_flashMode) {
            case AVCaptureFlashModeOn:
                self.flashOffButton.alpha =
                self.flashAutoButton.alpha = 0;
                self.bottomFlashControllOffset.constant = 24 - 2 * (8 + 45);
                break;
            case AVCaptureFlashModeOff:
                self.flashOnButton.alpha =
                self.flashAutoButton.alpha = 0;
                self.bottomFlashControllOffset.constant = 24 - 1 * (8 + 45);
                break;
            case AVCaptureFlashModeAuto:
                self.flashOnButton.alpha =
                self.flashOffButton.alpha = 0;
                self.bottomFlashControllOffset.constant = 24;
                break;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.flashModeSelectorOpened = NO;
        self.tapRecognizer.enabled = NO;
    }];
}

- (void)closeFlashModeSelector {
    if (self.flashModeSelectorOpened)
        self.flashMode = self.flashMode;
}

#pragma mark - actions

- (IBAction)onTap:(id)sender {
    [self closeFlashModeSelector];
}

- (IBAction)closeCamera:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)flashMode:(UIButton *)sender {
    if (!self.flashModeSelectorOpened) {
        [self openFlashModeSelector];
    } else {
        self.flashMode = (AVCaptureFlashMode)sender.tag;
    }
}

- (IBAction)switchCamera:(id)sender {
    [self closeFlashModeSelector];
}

@end
