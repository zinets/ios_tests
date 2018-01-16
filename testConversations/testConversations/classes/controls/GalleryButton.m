//
//  GalleryButton.m
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "GalleryButton.h"
#import "MiniMediaPicker.h"

@interface GalleryButton ()
@property (nonatomic, strong) UIView *inputView;
@end

@implementation GalleryButton

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)resignFirstResponder {
    self.selected = NO;
    return [super resignFirstResponder];    
}

-(UIView *)inputView {
    if (!_inputView) {
        _inputView = [[MiniMediaPicker alloc] initWithFrame:(CGRect){0, 0, 0, 258}];
        
        
        
        
    }
    return _inputView;
}

@end
