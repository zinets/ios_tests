//
//  ViewController.m
//  cropPhoto
//
//  Created by Zinets Viktor on 10/3/17.
//  Copyright © 2017 TogetherN. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCropController.h"
#import "PhotoCropAnimator.h"
#import "CropImagePreview.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv1;
@property (weak, nonatomic) IBOutlet UIImageView *iv2;
@property (weak, nonatomic) IBOutlet UIImageView *iv3;
@property (weak, nonatomic) IBOutlet CropImagePreview *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;

    UITapGestureRecognizer *tapr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    self.iv1.userInteractionEnabled = YES;
    [self.iv1 addGestureRecognizer:tapr];
    tapr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    self.iv2.userInteractionEnabled = YES;
    [self.iv2 addGestureRecognizer:tapr];
    tapr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    self.iv3.userInteractionEnabled = YES;
    [self.iv3 addGestureRecognizer:tapr];

    tapr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap2:)];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.image = [UIImage imageNamed:@"photo_p.jpg"];
    [self.imageView addGestureRecognizer:tapr];
}

- (IBAction)loadPortrait:(id)sender {
    _fromView = sender;
    [self loadWithPhoto:[UIImage imageNamed:@"photo_p.jpg"]];
}

- (IBAction)loadLandscape:(id)sender {
    _fromView = sender;
    [self loadWithPhoto:[UIImage imageNamed:@"photo_l.jpg"]];
}

- (IBAction)loadSmall:(id)sender {
    _fromView = sender;
    [self loadWithPhoto:[UIImage imageNamed:@"photo_s.jpg"]];
}

- (void)onTap2:(UITapGestureRecognizer *)sender {
    static BOOL b = NO;
    [UIView animateWithDuration:0.3 animations:^{
        if (!b) {
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;

        } else {
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        }
    }];
    b = !b;
}

- (void)onTap:(UITapGestureRecognizer *)sender {
    if (sender.view == self.iv1) {
        [self loadPortrait:sender.view];
    } else if (sender.view == self.iv2) {
        [self loadLandscape:sender.view];
    } else if (sender.view == self.iv3) {
        [self loadSmall:sender.view];
    }
}

- (void)loadWithPhoto:(UIImage *)photo {
    PhotoCropController *ctrl = [PhotoCropController new];
    ctrl.imageToCrop = photo;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - navbar

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    PhotoCropAnimator *animator = [PhotoCropAnimator new];
    animator.operation = operation;
    return animator;
}

@end
