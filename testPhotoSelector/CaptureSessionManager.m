//
//  CaptureSessionManager.m
//  Flirt
//
//  Created by Eugene Zhuk on 28.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import "CaptureSessionManager.h"
#import <AVFoundation/AVFoundation.h>

@interface CaptureSessionManager () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *output;
@property (nonatomic, strong) AVCaptureDeviceInput *frontCameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput *backCameraInput;

@property (nonatomic, assign) BOOL frontCameraEnabled;
@end

@implementation CaptureSessionManager
#pragma mark - public
- (BOOL)switchCameras
{
    return [self makeFrontCameraEnabled:!_frontCameraEnabled];
}

- (BOOL)flashEnabled
{
    AVCaptureDeviceInput *input = [_session.inputs lastObject];
    AVCaptureDevice *device = input.device;

    if([device respondsToSelector:@selector(hasFlash)])
        return [device hasFlash];

    return NO;
}

- (void)takePhotoWithCompletionHandler:(void (^)(UIImage *image))handler
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
            break;
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

        NSData *imageData = nil;
        @try
        {
            imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        }
        @catch (NSException *exception) {
            NSLog(@"Take picture error(jpegStillImageNSDataRepresentation:): %@", exception);
        }

        if(imageData)
        {
            UIImage *image = [UIImage imageWithData:imageData];
            if(handler)
            {
                handler([image copy]);
            }
        }
    }];
}

- (void)setFlashMode:(AVCaptureFlashMode)mode
{
    AVCaptureDevice *device = (AVCaptureDevice *)[[_session.inputs lastObject] device];
	if ([device isKindOfClass:[AVCaptureDevice class]]) {
		[device lockForConfiguration:nil];
		if ([device respondsToSelector:@selector(hasFlash)] && [device hasFlash])
			[device setFlashMode:mode];
		[device unlockForConfiguration];
	}
}

- (void)startSession
{
    [_session startRunning];
    _imageOutputView.image = nil;
    _imageOutputView.hidden = NO;
}

- (void)stopSession
{
    [_session stopRunning];
    _imageOutputView.image = nil;
    _imageOutputView.hidden = YES;
}

#pragma mark -
- (id)init
{
    self = [super init];

    if(self)
    {
        [self setupSession];
    }

    return self;
}

#pragma mark - AVCaptureSession
- (void)setupSession
{
    if(!_session)
    {
        _session = [[AVCaptureSession alloc] init];
#warning CRASH HERE on Simulator iOS 10 https://forums.developer.apple.com/thread/62230
        _session.sessionPreset = AVCaptureSessionPresetMedium;

        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
        [_stillImageOutput setOutputSettings:outputSettings];
        [_session addOutput:_stillImageOutput];

        _output = [[AVCaptureVideoDataOutput alloc] init];
        _output.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        _output.alwaysDiscardsLateVideoFrames = YES;
        [_session addOutput:_output];

        __weak CaptureSessionManager *weakRef = self;
        dispatch_queue_t queue = dispatch_queue_create("com.take_photo", NULL);
        [_output setSampleBufferDelegate:weakRef queue:queue];

        [self makeFrontCameraEnabled:NO];
        [self setFlashMode:AVCaptureFlashModeAuto];
    }
}

- (AVCaptureDeviceInput *)frontCameraInput
{
    if(!_frontCameraInput)
    {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionFront)
            {
                _frontCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                break;
            }
        }
    }
    return _frontCameraInput;
}

- (AVCaptureDeviceInput *)backCameraInput
{
    if(!_backCameraInput)
    {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionBack)
            {
                _backCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                break;
            }
        }
    }
    return _backCameraInput;
}

- (BOOL)makeFrontCameraEnabled:(BOOL)enabled
{
    _frontCameraEnabled = enabled;
    AVCaptureDeviceInput *inputToRemove = [_session.inputs lastObject];
    AVCaptureDeviceInput *inputToAdd = (enabled)?self.frontCameraInput:self.backCameraInput;
    [_session beginConfiguration];
    if(inputToRemove)[_session removeInput:inputToRemove];
    if(inputToAdd)[_session addInput:inputToAdd];
    [self fixOutputOrientation];
    [_session commitConfiguration];

    return [inputToAdd.device hasFlash];
}

- (void)fixOutputOrientation
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[_session.outputs lastObject] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_imageOutputView setImage:image];
    });
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);

    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);


    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];

    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return image;
}

@end
