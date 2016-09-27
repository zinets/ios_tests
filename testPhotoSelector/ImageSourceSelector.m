//
//  ImageSourceSelector.m
//  Flirt
//
//  Created by Eugene Zhuk on 7/18/16.
//  Copyright © 2016 Yarra. All rights reserved.
//

#import "ImageSourceSelector.h"
#import "PhotosGalleryView.h"
#import "ImageSorceButtonCellTableViewCell.h"
#import "PhotoGalleryAssetsManager.h"
#import "UIColor+MUIColor.h"

#define BUTTON_HEIGHT 60

@interface ImageSourceSelector () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, PhotosGalleryViewDelegate>
{
    UIView *_panel;
    PhotosGalleryView *_galleryView;
    UITableView *_buttonsTable;
}
@end

@implementation ImageSourceSelector
- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)onTap:(UIGestureRecognizer *)gesture {
    if (!CGRectContainsPoint(_panel.frame, [gesture locationInView:self])) {
        [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (CGRectContainsPoint(_panel.frame, [gestureRecognizer locationInView:self])) {
        return NO;
    }
    return YES;
}

- (NSInteger)cancelButtonIndex {
    return _otherButtonTitles.count;
}

- (BOOL)visible {
    return self.superview != nil;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    return [(ImageSorceButtonCellTableViewCell *)[_buttonsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:buttonIndex inSection:0]] title];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if ([_delegate respondsToSelector:@selector(imageSourceSelector:clickedButtonAtIndex:)]) {
        [_delegate imageSourceSelector:self clickedButtonAtIndex:buttonIndex];
    }
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _panel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, _panel.bounds.size.height);
            self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        } completion:^(BOOL finished) {
            if (finished) {
                [_galleryView setCameraSessionStarted:NO];
#warning [[FullScreenGuard instance] pop];
                [self removeFromSuperview];
            }
        }];
    } else {
#warning [[FullScreenGuard instance] pop];
        [self removeFromSuperview];
    }
}

- (void)showInView:(UIView *)view {
    [PhotoGalleryAssetsManager checkCameraAuthorizationStatusWithCompletion:^(BOOL cameraGranted) {
        [PhotoGalleryAssetsManager checkAuthorizationStatusWithCompletion:^(BOOL granted) {
            [self initUIForView:view galleryEnabled:granted];
#warning [[FullScreenGuard instance] pushView:self animated:NO];
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            
            _panel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, _panel.bounds.size.height);
            self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                _panel.transform = CGAffineTransformIdentity;
                self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
            } completion:^(BOOL finished) {
                if (finished) {
                    if (granted) {
                        [_galleryView setCameraSessionStarted:YES];
                    }
                }
            }];
        }];
    }];
}

- (void)initUIForView:(UIView *)view galleryEnabled:(BOOL)galleryEnabled {
    self.frame = view.bounds;
    
    BOOL shouldShowGallery = galleryEnabled;
    CGFloat galleryHeight = shouldShowGallery ? 88 + 4*2 : 0;
    CGFloat panelHeight = galleryHeight + BUTTON_HEIGHT * (_otherButtonTitles.count + 1);
    BOOL scrollEnabled = NO;
    if (panelHeight > view.bounds.size.height) {
        panelHeight = view.bounds.size.height;
        scrollEnabled = YES;
    }
    
    _panel = [[UIView alloc] initWithFrame:(CGRect){{0, self.bounds.size.height - panelHeight}, {self.bounds.size.width, panelHeight}}];
    _panel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_panel];
    
    if (shouldShowGallery) {
        _galleryView = [[PhotosGalleryView alloc] initWithFrame:(CGRect){{4, 4}, {_panel.bounds.size.width - 8, galleryHeight}}];
        _galleryView.delegate = self;
        _galleryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_panel addSubview:_galleryView];
    }
    
    
    _buttonsTable = [[UITableView alloc] initWithFrame:(CGRect){{0, _galleryView.frame.origin.y + _galleryView.bounds.size.height}, {_panel.bounds.size.width, _panel.bounds.size.height - _galleryView.bounds.size.height}}
                                                 style:UITableViewStylePlain];
    [_buttonsTable registerClass:[ImageSorceButtonCellTableViewCell class] forCellReuseIdentifier:@"cell"];
    _buttonsTable.dataSource = self;
    _buttonsTable.delegate = self;
    _buttonsTable.scrollEnabled = scrollEnabled;
    _buttonsTable.showsVerticalScrollIndicator = NO;
    _buttonsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _buttonsTable.backgroundColor = [UIColor clearColor];
    [_panel addSubview:_buttonsTable];
}

- (BOOL)isVisible {
    return self.superview != nil;
}
#pragma mark - table delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageSorceButtonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < _otherButtonTitles.count) {
        cell.title = _otherButtonTitles[indexPath.row];
        cell.icon = _otherButtonIcons[indexPath.row];
    } else {
        cell.title = _cancelButtonTitle;
        cell.icon = nil;
    }
    cell.separatorColor = (indexPath.row < _otherButtonIcons.count) ? [UIColor colorWithHex:0xdbdbdb] : [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BUTTON_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _otherButtonTitles.count + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissWithClickedButtonIndex:indexPath.row animated:YES];
}

#pragma PhotosGalleryViewDelegate

- (void)photosGalleryView:(PhotosGalleryView *)imageSourceSelector imageSelected:(UIImage *)image {
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
    if ([_delegate respondsToSelector:@selector(imageSourceSelector:imageSelected:)]) {
        [_delegate imageSourceSelector:self imageSelected:image];
    }
}

- (void)photosGalleryViewCameraClicked:(PhotosGalleryView *)imageSourceSelector {
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
    if ([_delegate respondsToSelector:@selector(imageSourceSelectorCameraClicked:)]) {
        [_delegate imageSourceSelectorCameraClicked:self];
    }
}

@end
