//
//  ViewController.m
//  testImageView
//
//  Created by Zinets Victor on 2/17/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "ImageView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ImageView *landscapeView;
@property (weak, nonatomic) IBOutlet ImageView *portraitView;
@property (weak, nonatomic) IBOutlet ImageView *squareView;

@end

@implementation ViewController

- (IBAction)portraitImageLoad:(id)sender {
    self.landscapeView.image = [UIImage imageNamed:@"ar_less.jpg"];
    self.portraitView.image = [UIImage imageNamed:@"ar_less.jpg"];
    self.squareView.image = [UIImage imageNamed:@"ar_less.jpg"];
}

- (IBAction)landscapeImageLoad:(id)sender {
    self.landscapeView.image = [UIImage imageNamed:@"ar_more.jpg"];
    self.portraitView.image = [UIImage imageNamed:@"ar_more.jpg"];
    self.squareView.image = [UIImage imageNamed:@"ar_more.jpg"];
}

- (IBAction)squareImageLoad:(id)sender {
    self.landscapeView.image = [UIImage imageNamed:@"ar_1.jpg"];
    self.portraitView.image = [UIImage imageNamed:@"ar_1.jpg"];
    self.squareView.image = [UIImage imageNamed:@"ar_1.jpg"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



@end
