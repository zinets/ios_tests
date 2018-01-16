//
//  GalleryButton.m
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "GalleryButton.h"
#import "MiniMediaPicker.h"

@interface GalleryButton () <MiniMediaPickerDelegate>
@property (nonatomic, strong) MiniMediaPicker *inputView;
@end

@implementation GalleryButton

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)resignFirstResponder {
    self.selected = NO;
    return [super resignFirstResponder];    
}

-(MiniMediaPicker *)inputView {
    if (!_inputView) {
        _inputView = [[MiniMediaPicker alloc] initWithFrame:(CGRect){0, 0, 320, 258}];       
        _inputView.delegate = self;
        
        
    }
    return _inputView;
}

- (void)miniMediaPickerWantsShowFullLibrary:(id)sender {
    if ([self.delegate respondsToSelector:@selector(galleryButtonWantsShowFullLibrary:)]) {
        [self.delegate galleryButtonWantsShowFullLibrary:self];
    }
}

- (void)miniMediaPicker:(id)sender didSelectAsset:(PHAsset *)asset {
    [self resignFirstResponder];
    _inputView = nil;
    
    if ([self.delegate respondsToSelector:@selector(galleryButton:didSelectMedia:)]) {
        [self.delegate galleryButton:self didSelectMedia:asset];
    }
}

@end
