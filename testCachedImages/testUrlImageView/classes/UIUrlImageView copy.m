//
//  UIUrlImageView.m
//  testCachedImages
//
//  Created by Zinetz Victor on 26.02.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "UIUrlImageView.h"
#import "UIView+Geometry.h"

@implementation UIUrlImageView

@synthesize url = _url;

-(id)initWithFrame:(CGRect)frame {
    self = [self initWithImage:[UIImage imageNamed:@"defaultImage"]];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
        if (!CGRectEqualToRect(frame, CGRectZero)) {
            self.frame = frame;
        }
        
        _data = [NSMutableData data];
        activity = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = CGRectGetCenter(self.bounds);
        activity.hidesWhenStopped = YES;
        [self addSubview:activity];
    }
    
    return self;
}

#pragma mark - set/getters

-(void)setUrl:(NSString *)url {
    if ([_url isEqualToString:url]) {
        return;
    }

    [activity startAnimating];
    
    _url = url;
    if (_connection) {
        [_connection cancel];
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - delegates

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [activity stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage * img = [UIImage imageWithData:_data];
    self.image = img;
    
    [activity stopAnimating];
}

@end
