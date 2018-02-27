//
//  CameraController.m
//  cameraTest
//
//  Created by Victor Zinets on 2/27/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "CameraController.h"
#import "UIColor+InputMethods.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraController () {
    AVCaptureSession *captureSession;
    dispatch_queue_t captureSessionQueue;
}
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

// photo/video mode
@property (nonatomic) BOOL isVideoMode; // инача photo

// camera hardware
@property (nonatomic, strong) AVCaptureDevice *selfieCamera;
@property (nonatomic, strong) AVCaptureDevice *mainCamera;
@property (nonatomic, strong) AVCaptureDevice *activeCamera;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation CameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // gradient
    [self addGradient];
    self.flashMode = AVCaptureFlashModeAuto;
    
    [self prepareCamera];
    [self createCameraInput];
}

- (void)addGradient {
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[
                     (id)[[UIColor colorWithHex:0x363636] colorWithAlphaComponent:0].CGColor,
                     (id)[UIColor colorWithHex:0xca000000].CGColor
                     ];
    layer.startPoint = (CGPoint){0, 0};
    layer.endPoint = (CGPoint){0, 1};
    layer.frame = (CGRect){0, self.view.bounds.size.height - 153, self.view.bounds.size.width, 153};
    [self.view.layer insertSublayer:layer atIndex:0];
}

#pragma mark - camera

- (void)prepareCamera {
    captureSessionQueue = dispatch_queue_create("capture_session", DISPATCH_QUEUE_SERIAL);
    captureSession = [AVCaptureSession new];
    captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    _previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:_previewLayer atIndex:1];
    
    NSArray <AVCaptureDevice *> *arr = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    [arr enumerateObjectsUsingBlock:^(AVCaptureDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.position == AVCaptureDevicePositionFront) {
            self.selfieCamera = obj;
        } else if (obj.position == AVCaptureDevicePositionBack) {
            self.mainCamera = obj;
        }
    }];
    self.switchCameraButton.enabled = self.selfieCamera && self.mainCamera;
    self.activeCamera = self.mainCamera;
    if (!self.activeCamera) {
        self.activeCamera = self.selfieCamera;
    }
}

- (void)createCameraInput {
    if (captureSession.isRunning) {
        dispatch_async(captureSessionQueue, ^{
            [captureSession stopRunning];
        });
    }
    
    dispatch_async(captureSessionQueue, ^{
        [captureSession beginConfiguration];
        
        NSError *err = nil;
        AVCaptureInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.activeCamera error:&err];
        if (!err) {
            [[captureSession inputs] enumerateObjectsUsingBlock:^(__kindof AVCaptureInput * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [captureSession removeInput:obj];
            }];
            if ([captureSession canAddInput:cameraInput]) {
                [captureSession addInput:cameraInput];
            }
        }
        
        [captureSession commitConfiguration];
    });
    
    dispatch_async(captureSessionQueue, ^{
        [captureSession startRunning];
    });
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
    }];
}

- (void)closeFlashModeSelector {
    if (self.flashModeSelectorOpened)
        self.flashMode = self.flashMode;
}

#pragma mark - actions

- (IBAction)onPreviewTap:(UITapGestureRecognizer *)sender {
    if (self.flashModeSelectorOpened) {
        [self closeFlashModeSelector];
    } else if (self.activeCamera) {
        CGPoint pt = [sender locationInView:sender.view];
        CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:pt];
        
        NSError *err = nil;
        if ([self.activeCamera lockForConfiguration:&err]) {

            self.activeCamera.focusPointOfInterest = cameraPoint;
            self.activeCamera.focusMode = AVCaptureFocusModeAutoFocus;
            
            [self.activeCamera unlockForConfiguration];
        }
        
    }
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
    if (self.activeCamera == self.mainCamera) {
        self.activeCamera = self.selfieCamera;
    } else {
        self.activeCamera = self.mainCamera;
    }
    [self createCameraInput];
}

- (IBAction)onShutterTap:(id)sender {
    [self closeFlashModeSelector];
}

// все переделать; появляется после того, как сделали фото/видео
- (IBAction)retake:(id)sender {
}

- (IBAction)onContinueTap:(id)sender {
}

@end
