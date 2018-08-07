//
//  ViewController.m
//  videoPreview
//
//  Created by Victor Zinets on 8/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "VideoPreview.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet VideoPreview *videoPreviewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoPreviewView.autostart = YES;
}

-(NSString *)previewUrl {
    return @"https://flirt-com-rel-stage.platformphoenix.com/video/preview/id/8918a019e19d44a8bd4ee6e083f4902f";
}

-(NSString *)slideshowUrl {
    return @"https://flirt-com-rel-stage.platformphoenix.com/video/slideshow/id/8918a019e19d44a8bd4ee6e083f4902f";
}

- (NSString *)videoUrl {
    return @"https://flirt-com-rel-stage.platformphoenix.com/video/show/id/8918a019e19d44a8bd4ee6e083f4902f";
}

- (IBAction)openUrl:(UIButton *)sender {
    NSString *url = nil;
    switch (sender.tag) {
//        case 1:
//            url = self.previewUrl;
//            break;
        case 2:
            url = self.slideshowUrl;
            break;
        case 3:
            url = self.videoUrl;
            break;
        default:
            break;
    }

    
    [self.videoPreviewView loadVideo:url preview:self.previewUrl];
}


@end
