//
//  ViewController.m
//
//  Created by Zinets Victor on 3/1/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+LetterByLetterAnimation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AnimatedTypiingLabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onTap:(id)sender {
    [self.label setText:@"It’s really nice that your boobs are so big and tasty\nOm-nom-nom\n\nЯ б ей вдул - ты б и в мелкодисперсную грязь вдул!\n\nAnswers 5 match questions to calculate better matches" animated:YES];

}


@end
