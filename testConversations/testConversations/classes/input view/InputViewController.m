//
//  InputViewController.m
//  testConversations
//
//  Created by Zinets Viktor on 1/15/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "InputViewController.h"
#import "GrowingTextView.h"

@interface InputViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet GrowingTextView *textInputView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *galleryButtonWidth;


@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *postButton;


@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark setters

-(void)setCameraButtonVisible:(BOOL)cameraButtonVisible {
    _cameraButtonVisible = cameraButtonVisible;
    self.cameraButtonWidth.constant = _cameraButtonVisible ? 48 : 0;
    
    self.preferredContentSize = [self recalculatedHeight];
}

-(void)setGalleryButtonVisible:(BOOL)galleryButtonVisible {
    _galleryButtonVisible = galleryButtonVisible;
    self.galleryButtonWidth.constant = _galleryButtonVisible ? 48 : 0;
    
    self.preferredContentSize = [self recalculatedHeight];
}

#pragma mark actions

- (IBAction)onCameraButtonTap:(id)sender {
    self.cameraButtonVisible = NO;
}

- (IBAction)onGalleryButtonTap:(id)sender {
    self.galleryButtonVisible = NO;
}

- (IBAction)onPostButtonTap:(id)sender {
    self.galleryButtonVisible = !self.cameraButtonVisible;
}

#pragma mark text delegate

- (CGSize)recalculatedHeight {
    CGSize sz = self.contentView.bounds.size;
    
    [self.view layoutIfNeeded];
    sz = self.contentView.bounds.size;
    
    return sz;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.preferredContentSize = [self recalculatedHeight];
}

@end
