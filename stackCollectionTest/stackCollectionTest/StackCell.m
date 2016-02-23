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
    self.images = nil;
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
    testLabel.text = _title;
    [testLabel sizeToFit];
}

//-(void)setDepth:(CGFloat)depth {    
//    _depth = depth;
////    self.alpha = 1 - _depth;
//    
//    static CGFloat const magicK = 0.35;
//    static CGFloat const maxDepthHeight = 25; // макс сдвиг вверх ячейки
//    CGFloat k = _depth * magicK;
//    CGFloat kh = magicK * 415 / 2; // компенсация сжатия для правильного сдвига вверх
//    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformTranslate(transform, 0, - _depth * (maxDepthHeight + kh));
//    k = 1 - k;
//    transform = CGAffineTransformScale(transform, k, k);
//    
//    self.transform = transform;
//}


#pragma mark - photos

- (NSInteger)numberOfPhotos {
    return self.images.count;
}

- (UIView *)scroller:(PhotoScrollerView *)scroller viewForIndex:(NSInteger)index {
    UrlImageView2 *res = (id)[scroller dequeueView];
    if (!res) {
        res = [[UrlImageView2 alloc] initWithFrame:scroller.bounds];
        res.contentMode = UIViewContentModeScaleAspectFill;
        res.clipsToBounds = YES;
    }
    [res loadImageFromUrl:self.images[index]];
    return res;
}

@end
