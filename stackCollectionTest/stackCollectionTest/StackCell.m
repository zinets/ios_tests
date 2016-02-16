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

@interface StackCell () <PhotoScrollerViewProto> {
    NSMutableArray *images;
}

@end

@implementation StackCell {
    UILabel *testLabel;
    PhotoScrollerView *photos;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    photos.contentOffset = CGPointZero;
    [images removeAllObjects];
    for (int x = 0; x < 4; x++) {
        NSString *fn = [NSString stringWithFormat:@"p%ld.jpg", random() % 16];
        [images addObject:fn];
    }
}

-(void)setTitle:(NSString *)title {
    _title = title;
    testLabel.text = _title;
    [testLabel sizeToFit];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        images = [NSMutableArray arrayWithCapacity:4];
        for (int x = 0; x < 4; x++) {
            NSString *fn = [NSString stringWithFormat:@"p%ld.jpg", random() % 16];
            [images addObject:fn];
        }
        
        photos = [[PhotoScrollerView alloc] initWithFrame:self.bounds];
        photos.dataSource = self;
        photos.verticalScrolling = YES;
        [self.contentView addSubview:photos];
        
        self.contentView.backgroundColor = [UIColor colorWithHex:random() & 0x00ffffff];
        
        testLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        [self.contentView addSubview:testLabel];
        
    }
    return self;
}

-(void)applyLayoutAttributes:(StackCellAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
//    if (CATransform3DEqualToTransform(layoutAttributes.transform3D, CATransform3DIdentity)) {
        CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"transform"];
        [self.layer addAnimation:a forKey:@"animate"];
//    }
    
    [photos reloadPhotos];
}

#pragma mark - photos

- (NSInteger)numberOfPhotos {
    return images.count;
}

- (UIView *)scroller:(PhotoScrollerView *)scroller viewForIndex:(NSInteger)index {
    UIImageView *res = (id)[scroller dequeueView];
    if (!res) {
        res = [[UIImageView alloc] initWithFrame:scroller.bounds];
        res.contentMode = UIViewContentModeScaleAspectFill;
        res.clipsToBounds = YES;
    }
    res.image = [UIImage imageNamed:images[index]];
    return res;
}

@end
