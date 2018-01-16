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
    self.text = @"";
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

-(void)setText:(NSString *)text {
    self.textInputView.text = text;
    
    self.postButton.enabled = /* todo проверка валидности текста */ text.length > 0;
}

-(NSString *)text {
    return self.textInputView.text;
}

#pragma mark actions

- (IBAction)onCameraButtonTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputView:didSelectButton:)]) {
        [self.delegate inputView:self didSelectButton:(InputViewButtonCamera)];
    }
    // тут имо без вариантов надо убрать клавиатуру - щас перейдем в фотопарат
    [self.textInputView resignFirstResponder];
}

- (IBAction)onGalleryButtonTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputView:didSelectButton:)]) {
        [self.delegate inputView:self didSelectButton:(InputViewButtonGallery)];
    }
    // тапы по кнопкам должны убирать клавиатуру? может не нужно и она "сама" как-то там уберется?.. заменится на экран выбора фото к примеру
}

- (IBAction)onPostButtonTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputView:didSelectButton:)]) {
        [self.delegate inputView:self didSelectButton:(InputViewButtonPostMessage)];
    }
    [self.textInputView resignFirstResponder];
    // а кто и где/когда обнулит текст? наверное кто-то "там" - вдруг текст сразу не отошлется? платежка там и прочее.. а когда отошлется - тогда и обнулит
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
    
    self.postButton.enabled = textView.text.length > 0;
}

@end
