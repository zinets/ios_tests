//
//  ViewController.m
//  testUrlImageView
//
//  Created by Zinetz Victor on 26.02.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "ViewController.h"
#import "UIUrlImageView.h"
#import "UIView+Geometry.h"

@interface ViewController () {
    UIUrlImageView * iv;
    NSArray * arr;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    arr = @[@"http://img707.imageshack.us/img707/4918/p9240820.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/_-5DCwETwOFQAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/_a9fCQGPepdPAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/Tur9CQEXDtFPAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/zllrBwH7ZBVPAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/tXN2BwHyYRdPAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/eIDGCAG55HNPAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/W-HrBQGX0EhOAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/gOfkCAEbNn5PAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/h2WcCAFlal9PAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/Uzm8CAEHPGpPAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/munnBwFoezFPAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/XpWxBwEbQk9PAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/pgTEBwFSvClPAQAAAA==.jpg",
            @"http://cdn.imgstat.com/static/photo/thumbnail/a7pBBgGRMoxOAQAAAA==.jpg"];
    
    iv = [[UIUrlImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:iv];
    
    iv.left = 20;
    iv.top = 20;
    int ind = random() % arr.count;
    iv.url = arr[ind];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTestClick:(id)sender {
    int ind = random() % arr.count;
    iv.url = arr[ind];
    
}

@end
