//
//  ViewController.m
//  animatedText
//
//  Created by Zinets Victor on 3/1/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+LetterByLetterAnimation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onTap:(id)sender {
    [self.label animateTextAppearing:@"It’s really nice that your boobs are so big and tasty" charDelay:1 / 100.];
}


@end
