//
//  ViewController.m
//  somethingPager
//
//  Created by Victor Zinets on 4/16/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "SPager.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet SPager *testPager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.testPager.dataSource = @[
                              [PagerItem newPagerItemWithTitle:@"Check out any profiles with video you want" descr:@"Upgrade now and choose from loads of potential dates!" image:@"slide-likepower"],
                              [PagerItem newPagerItemWithTitle:@"2" descr:@"222 2 222222" image:@"slide-likes"],
                              [PagerItem newPagerItemWithTitle:@"3" descr:@"333 333 333 333 333 333 \n 333 333 333 333 333" image:@"slide-messages"],
                              ];
    [self.view addSubview:self.testPager];
}

- (IBAction)onBack:(id)sender {
    self.testPager.currentPage--;
}

- (IBAction)onForward:(id)sender {
    self.testPager.currentPage++;
}

@end
