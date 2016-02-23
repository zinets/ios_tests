//
//  StackCell.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackCell.h"
#import "PhotoScrollerView.h"
#import "StackCellAttributes.h"
#import "UrlImageView2.h"

@interface StackCell () <PhotoScrollerViewProto> {
    UIView *cv;
}

@end

@implementation StackCell {
    UILabel *testLabel;
    PhotoScrollerView *photos;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    photos.contentOffset = CGPointZero;
//    self.images = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        
        photos = [[PhotoScrollerView alloc] initWithFrame:self.bounds];
        photos.dataSource = self;
        photos.verticalScrolling = YES;
        [self.contentView addSubview:photos];
        
        self.contentView.backgroundColor = [UIColor colorWithHex:random() & 0x00ffffff];
        
        testLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        testLabel.numberOfLines = 0;
        [self.contentView addSubview:testLabel];
        
        cv = [[UIView alloc] initWithFrame:(CGRect){{0, 0}, {10, 10}}];
        cv.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:cv];
        
//        self.depth = 1;        
    }
    return self;
}


#pragma mark - setters

-(void)setImages:(NSArray *)images {
    _images = images;
    [photos reloadPhotos];
}

-(void)setTitle:(NSString *)title {
    _title = title;
    testLabel.text = [NSString stringWithFormat:@"%@\naddr: %p\nphotos: %p", _title, self, photos];
    [testLabel sizeToFit];
}

#pragma mark - photos

- (NSInteger)numberOfPhotos {
    return self.images.count;
}

- (UIView *)scroller:(PhotoScrollerView *)scroller viewForIndex:(NSInteger)index {
    UIImage *img = [UIImage imageNamed:self.images[index]];
    if (img) {
        UIImageView *res = (id)[scroller dequeueView];
        if (!res) {
            res = [[UIImageView alloc] initWithFrame:scroller.bounds];
            res.contentMode = UIViewContentModeScaleAspectFill;
            res.clipsToBounds = YES;
        }
        res.image = img;
        
        return res;
    } else {
        UrlImageView2 *res = (id)[scroller dequeueView];
        if (!res) {
            res = [[UrlImageView2 alloc] initWithFrame:scroller.bounds];
            res.allowLoadingAnimation = NO;
            res.contentMode = UIViewContentModeScaleAspectFill;
            res.clipsToBounds = YES;
        }

        [res loadImageFromUrl:self.images[index]];
        
        return res;
    }
}

@end
