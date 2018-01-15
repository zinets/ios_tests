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

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize sz = self.contentView.bounds.size;
    
    [self.view layoutIfNeeded];
    sz = self.contentView.bounds.size;
    
    self.preferredContentSize = sz;
}

@end
