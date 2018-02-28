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

@interface CameraController () <AVCaptureFileOutputRecordingDelegate> {
    AVCaptureSession *captureSession;
    dispatch_queue_t captureSessionQueue;
}
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *shutterButton;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

// flash control
@property (weak, nonatomic) IBOutlet UIButton *flashOnButton;
@property (weak, nonatomic) IBOutlet UIButton *flashOffButton;
@property (weak, nonatomic) IBOutlet UIButton *flashAutoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFlashControllOffset;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) AVCaptureFlashMode flashMode;
@property (nonatomic) BOOL flashModeSelectorOpened;

// camera hardware
@property (nonatomic, strong) AVCaptureDevice *selfieCamera;
@property (nonatomic, strong) AVCaptureDevice *mainCamera;
@property (nonatomic, strong) AVCaptureDevice *activeCamera;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *videoOutput;

// postprocess
@property (weak, nonatomic) IBOutlet UIImageView *photoPreview;

@end

@implementation CameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning hardcoded mode
    self.isVideoMode = NO;
    
    [self tuneUI];
    
    [self prepareCamera];
    [self createCameraInput];
    if (self.isVideoMode) {
        [self createVideoOutput];
    } else {
        [self createPhotoOutput];
    }
    
    self.flashMode = AVCaptureFlashModeAuto;
}

- (void)tuneUI {
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[
                     (id)[[UIColor colorWithHex:0x363636] colorWithAlphaComponent:0].CGColor,
                     (id)[UIColor colorWithHex:0xca000000].CGColor
                     ];
    layer.startPoint = (CGPoint){0, 0};
    layer.endPoint = (CGPoint){0, 1};
    layer.frame = (CGRect){0, self.view.bounds.size.height - 153, self.view.bounds.size.width, 153};
    [self.view.layer insertSublayer:layer atIndex:0];
    
    self.closeButton.layer.cornerRadius = 56/2;
    self.playButton.layer.cornerRadius = 64/2;
}

#pragma mark - camera

- (void)prepareCamera {
    captureSessionQueue = dispatch_queue_create("capture_session", DISPATCH_QUEUE_SERIAL);
    captureSession = [AVCaptureSession new];
    // AVCaptureSessionPresetLow - .. for sharing over 3G
    // AVCaptureSessionPresetMedium - .. for sharing over WiFi
    // AVCaptureSessionPreset1280x720 - облезут они снимать пиписки с таким качеством
    captureSession.sessionPreset = self.isVideoMode ? AVCaptureSessionPresetLow : AVCaptureSessionPresetPhoto;
    
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

- (void)createPhotoOutput {
    dispatch_async(captureSessionQueue, ^{
        _imageOutput = [AVCaptureStillImageOutput new];
        if ([captureSession canAddOutput:_imageOutput]) {
            [captureSession addOutput:_imageOutput];
        }
    });
}

- (void)createVideoOutput {
    dispatch_async(captureSessionQueue, ^{
        _videoOutput = [AVCaptureMovieFileOutput new];
        if ([captureSession canAddOutput:_videoOutput]){
            [captureSession addOutput:_videoOutput];
        }
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
    [UIView animateWithDuration:0.4 animations:^{
        if ([self.activeCamera isFlashModeSupported:flashMode]) {
            _flashMode = flashMode;
            
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
            
            dispatch_async(captureSessionQueue, ^{
                NSError *err = nil;
                [self.activeCamera lockForConfiguration:&err];
                if (!err) {
                    self.activeCamera.flashMode = _flashMode;
                    
                    [self.activeCamera unlockForConfiguration];
                }
            });
        } else {
            
        }
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
    } else if ([self.activeCamera isFocusPointOfInterestSupported]) {
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
    
    self.flashOffButton.enabled =
    self.flashOnButton.enabled =
    self.flashAutoButton.enabled = [self.activeCamera hasFlash];    
    
    [self createCameraInput];
}

- (IBAction)onShutterTap:(id)sender {
    [self closeFlashModeSelector];
    if (self.isVideoMode) {
        [self getVideo];
    } else {
        [self getImage];
    }
}

// все переделать; появляется после того, как сделали фото/видео
- (IBAction)retake:(id)sender {
    self.photoPreview.image = nil;
    self.photoPreview.alpha = 0;
    
//    self.videoPreview = ...
    
    self.retakeButton.hidden = YES;
    self.continueButton.hidden = YES;
}

- (IBAction)onContinueTap:(id)sender {
}

#pragma mark -

- (void)getImage {
    dispatch_async(captureSessionQueue, ^{
        AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
        if (connection.isVideoOrientationSupported) {
            connection.videoOrientation = (AVCaptureVideoOrientation)[UIDevice currentDevice].orientation;
        }
        
        [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
            if (!error) {
                NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [UIImage imageWithData:jpegData];
                
                // flip selfie camera output; сначала отразить если надо..
                if (self.activeCamera == self.selfieCamera) {
                    image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:(UIImageOrientationLeftMirrored)];
                }
                
                // .. а потом уменьшить; иначе (уменьшить, а потом отраать, что казалось бы лучше с точки зрения использования памяти) получается магия с поворотами картинки; а так все работает "само собой"
                CGFloat const serverMaxSize = 1024;
                CGFloat ar = serverMaxSize / MAX(image.size.width, image.size.height);
                CGSize newSize = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(ar, ar));
                
                UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
                [image drawInRect:(CGRect){CGPointZero, newSize}];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showPhotoPreview:image];
                });
            } else {
                NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
            }
        }];
    });
}

- (void)getVideo {
    if (self.shutterButton.selected) {
        dispatch_async(captureSessionQueue, ^{
            [self.videoOutput stopRecording];
        });
    } else {
        dispatch_async(captureSessionQueue, ^{
            NSString *temp = [NSTemporaryDirectory() stringByAppendingPathComponent:@"video.tmp"];
            NSURL *outputUrl = [[NSURL alloc] initFileURLWithPath:temp isDirectory:NO];
            [self.videoOutput startRecordingToOutputFileURL:outputUrl recordingDelegate:self];
        });
    }
    self.shutterButton.selected = !self.shutterButton.selected;
}

- (void)showPhotoPreview:(UIImage *)image {
    self.photoPreview.image = image;
    self.photoPreview.alpha = 1;

    self.retakeButton.hidden = NO;
    self.continueButton.hidden = NO;
}

- (void)showVideoPreview:(id)param {
    
}

#pragma mark - capture delegation

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(nullable NSError *)error {
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, outputFileURL, error);
    [self showVideoPreview:outputFileURL];
    
}

- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    
}

//todo:
//- таймер записи видео
//- ресайз фото для отправки
//- проверить видео

@end
