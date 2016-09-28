//
//  FlirtTakePhotoControllerViewController.m
//
//  Created by Eugene Zhuk on 27.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import "TakePhotoControllerViewController.h"
#import "CameraFlashControl.h"
#import "CaptureSessionManager.h"

@interface TakePhotoControllerViewController ()
{
    UIImageView *_gridView;
    CameraFlashControl *_flashControl;
}
@property (nonatomic, strong) CaptureSessionManager *cameraManager;
@end

@implementation TakePhotoControllerViewController

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];

    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 51);
    UIView *topView = [[UIView alloc] initWithFrame:frame];
    topView.backgroundColor = [UIColor yellowColor];
#warning design setup //(!is35InchScreen())?[AppDesigner colorFor:iePhotoScreenBars]:[UIColor clearColor];
    [self.view addSubview:topView];
    
#warning design setup    InterfaceElement el = (!is35InchScreen())?iePhotoScreenGridButtonNoBg:iePhotoScreenGridButton;
//    ColorButton *gridButton = [ColorButton buttonWithPresetsFor:el target:self action:@selector(onGrid)];
//	[gridButton sizeToFit];
//    if(is35InchScreen())gridButton.width = 49;
//    gridButton.left = (!is35InchScreen())?41:10;
//    gridButton.top = (topView.height - gridButton.height)/2;
    UIButton *gridButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    gridButton.frame = (CGRect){{41, (topView.bounds.size.height - 35) / 2}, {49, 35}};
    [gridButton setImage:[UIImage imageNamed:@"take-photo_transparent-button-icons_grid"]
                forState:(UIControlStateNormal)];
    [gridButton setBackgroundImage:[UIImage imageNamed:@"take-photo_trans-button-bg"]
                          forState:(UIControlStateNormal)];
    [topView addSubview:gridButton];
/*
    ColorButton *switchCameraButton = [ColorButton buttonWithPresetsFor:(!is35InchScreen())?iePhotoScreenSwitchCameraButtonNoBg:iePhotoScreenSwitchCameraButton target:self action:@selector(onSwitchCamera)];
	[switchCameraButton sizeToFit];
    if(is35InchScreen())switchCameraButton.width = 49;
    switchCameraButton.right = (!is35InchScreen())?topView.width - 41:topView.width - 10;
    switchCameraButton.top = (topView.height - switchCameraButton.height)/2;
    [topView addSubview:switchCameraButton];

    _flashControl = [[FlirtCameraFlashControl alloc] initWithYOffset:(!is35InchScreen())?8:5];
    [_flashControl addTarget:self action:@selector(onFlashModeAction:) forControlEvents:UIControlEventValueChanged];
    [topView addSubview:_flashControl];

    frame = CGRectMake(0, 0, self.view.width, (!is35InchScreen())?90:53);
    UIView *bottomToolbarBg = [[UIView alloc] initWithFrame:frame];
    bottomToolbarBg.bottom = self.view.height;
    bottomToolbarBg.backgroundColor = [AppDesigner colorFor:iePhotoScreenBars];
    [self.view addSubview:bottomToolbarBg];

    ColorButton * doneButton = [ColorButton buttonWithPresetsFor:(!is35InchScreen()?iePhotoScreenTakePhotoButton:iePhotoScreenTakePhotoButton35Inch) target:self action:@selector(onDoneAction:)];
    doneButton.center = CGPointMake(bottomToolbarBg.width/2, bottomToolbarBg.height/2);
    [bottomToolbarBg addSubview:doneButton];

    ColorButton *backButton = [[ColorButton buttonWithPresetsFor:iePhotoScreenBackButton target:self action:@selector(onBackAction)] setTitle:Localized(@"CANCEL")];
	[backButton sizeToFit];
    backButton.top = (bottomToolbarBg.height - backButton.height)/2;
    backButton.left = 15;
    [bottomToolbarBg addSubview:backButton];

    frame = CGRectMake(0, (!is35InchScreen())?topView.bottom:0, self.view.width, (!is35InchScreen())?self.view.height - topView.bottom - bottomToolbarBg.height:self.view.height - bottomToolbarBg.height);
*/
    UIImageView *outputView = [[UIImageView alloc] initWithFrame:frame];
    outputView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:outputView atIndex:0];
/*
    _gridView = [[UIImageView alloc] initWithFrame:outputView.bounds];
    _gridView.image = [AppDesigner imageFor:iePhotoScreenGrid];
    _gridView.hidden = YES;
    [outputView addSubview:_gridView];
*/
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%@ dealocated.", NSStringFromClass([self class]));
}

#pragma mark - actions
-(void)onDoneAction:(id)sender {

    __weak TakePhotoControllerViewController *bSelf = self;
    [_cameraManager takePhotoWithCompletionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(image)
            {
                [_cameraManager stopSession];
                if([bSelf.delegate respondsToSelector:@selector(takePhotoController:didFinishPickingImage:)])
                    [bSelf.delegate takePhotoController:self didFinishPickingImage:image];
            }
        });
    }];

}

- (void)onFlashModeAction:(CameraFlashControl *)sender
{
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

- (void)onSwitchCamera
{
    _flashControl.hidden = ![_cameraManager switchCameras];
}

- (void)onBackAction
{
    if([_delegate respondsToSelector:@selector(takePhotoControllerDidCancel:)])
        [_delegate takePhotoControllerDidCancel:self];
}

@end
