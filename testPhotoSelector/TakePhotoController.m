//
//  FlirtTakePhotoController.m
//
//  Created by Eugene Zhuk on 27.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import "TakePhotoController.h"
#import "CameraFlashControl.h"
#import "CaptureSessionManager.h"

@interface TakePhotoController ()
{
    UIImageView *_gridView;
    CameraFlashControl *_flashControl;
}
@property (nonatomic, strong) CaptureSessionManager *cameraManager;
@end

@implementation TakePhotoController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];

    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 51);
    UIView *topView = [[UIView alloc] initWithFrame:frame];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    UIButton *gridButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    gridButton.frame = (CGRect){{41, (topView.bounds.size.height - 35) / 2}, {49, 35}};
    [gridButton setImage:[UIImage imageNamed:@"take-photo_transparent-button-icons_grid"] forState:(UIControlStateNormal)];
    //  фоновая картинка была в 3.5"  [gridButton setBackgroundImage:[UIImage imageNamed:@"take-photo_trans-button-bg"] forState:(UIControlStateNormal)];
    [gridButton addTarget:self action:@selector(onGrid) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:gridButton];
    
    UIButton *switchCameraButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    switchCameraButton.frame = (CGRect){{topView.bounds.size.width - 49 - 41, (topView.bounds.size.height - 35) / 2}, {49, 35}};
    [switchCameraButton setImage:[UIImage imageNamed:@"take-photo_transparent-button-icons_flip"] forState:(UIControlStateNormal)];
    //  фоновая картинка была в 3.5"  [switchCameraButton setBackgroundImage:[UIImage imageNamed:@"take-photo_trans-button-bg"] forState:(UIControlStateNormal)];
    [switchCameraButton addTarget:self action:@selector(onSwitchCamera) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:switchCameraButton];
    
    _flashControl = [[CameraFlashControl alloc] initWithYOffset:8];
#warning как задаются размеры??
    [_flashControl addTarget:self action:@selector(onFlashModeAction:) forControlEvents:UIControlEventValueChanged];
    [topView addSubview:_flashControl];
    
    frame = CGRectMake(0, self.view.bounds.size.height - 90, self.view.bounds.size.width, 90);
    UIView *bottomToolbarBg = [[UIView alloc] initWithFrame:frame];
    bottomToolbarBg.backgroundColor = [UIColor blackColor]; // тут был "почти-чорный-как-цыган"
    [self.view addSubview:bottomToolbarBg];

    UIButton *doneButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [doneButton setImage:[UIImage imageNamed:@"take-photo-camera-icon"] forState:(UIControlStateNormal)];
    doneButton.frame = (CGRect){{}, {70, 70}};
    doneButton.center = CGPointMake(bottomToolbarBg.bounds.size.width / 2, bottomToolbarBg.bounds.size.height / 2);
    doneButton.layer.cornerRadius = 35;
    doneButton.backgroundColor = [UIColor greenColor];
    [doneButton addTarget:self action:@selector(onDoneAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomToolbarBg addSubview:doneButton];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
#warning localize me!
    [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [backButton setTitle:@"Cancel" forState:(UIControlStateNormal)];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(onBackAction) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.center = (CGPoint){15 + backButton.bounds.size.width / 2, bottomToolbarBg.bounds.size.height / 2};
    [bottomToolbarBg addSubview:backButton];
    
    frame = (CGRect){{0, topView.bounds.size.height}, {self.view.bounds.size.width, self.view.bounds.size.height - topView.bounds.size.height - bottomToolbarBg.bounds.size.height}};
    
    UIImageView *outputView = [[UIImageView alloc] initWithFrame:frame];
    outputView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:outputView atIndex:0];

    _gridView = [[UIImageView alloc] initWithFrame:outputView.bounds];
    _gridView.image = [UIImage imageNamed:@"take-photo_grid"];
    _gridView.hidden = YES;
    [outputView addSubview:_gridView];

    _cameraManager = [[CaptureSessionManager alloc] init];
    _cameraManager.imageOutputView = outputView;

    _flashControl.hidden = ![_cameraManager flashEnabled];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_cameraManager startSession];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [_cameraManager stopSession];
}

#ifdef DEBUG
- (void)dealloc
{
    NSLog(@"%@ dealocated.", NSStringFromClass([self class]));
}
#endif

#pragma mark - actions

-(void)onDoneAction:(id)sender {
    __weak TakePhotoController *bSelf = self;
    [_cameraManager takePhotoWithCompletionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                if ([bSelf.delegate respondsToSelector:@selector(takePhotoController:didFinishPickingImage:)]) {
                    [_cameraManager stopSession];
                    [bSelf.delegate takePhotoController:self didFinishPickingImage:image];
                }
            }
        });
    }];
}

- (void)onFlashModeAction:(CameraFlashControl *)sender {
    switch (sender.cameraState) {
        case CameraFlashStateAuto:
            [_cameraManager setFlashMode:AVCaptureFlashModeAuto];
            break;
        case CameraFlashStateOn:
            [_cameraManager setFlashMode:AVCaptureFlashModeOn];
            break;
        case CameraFlashStateOff:
            [_cameraManager setFlashMode:AVCaptureFlashModeOff];
            break;

        default:
            break;
    }
}

- (void)onGrid
{
    _gridView.hidden = !_gridView.hidden;
}

- (void)onSwitchCamera {
    _flashControl.hidden = ![_cameraManager switchCameras];
}

- (void)onBackAction {
    if([_delegate respondsToSelector:@selector(takePhotoControllerDidCancel:)])
        [_delegate takePhotoControllerDidCancel:self];
}

@end
