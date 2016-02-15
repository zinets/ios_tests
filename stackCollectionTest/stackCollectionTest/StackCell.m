//
//  StackCell.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackCell.h"
#import "PhotoScrollerView.h"

@interface StackCell () <PhotoScrollerViewProto> {
    NSMutableArray *images;
}

@end

@implementation StackCell {
    UILabel *testLabel;
    PhotoScrollerView *photos;
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

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    testLabel.text = [NSString stringWithFormat:@"cell %@", @(layoutAttributes.indexPath.item)];
    [testLabel sizeToFit];
    
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
    }
    res.image = [UIImage imageNamed:images[index]];
    return res;
}

@end
