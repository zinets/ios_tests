//
//  MediaScrollerViewLayout.m
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "MediaScrollerViewLayout.h"
#import "MediaScrollerLayoutAttributes.h"

@implementation MediaScrollerViewLayout {
    NSInteger lastIndex;
}

+(Class)layoutAttributesClass {
    return [MediaScrollerLayoutAttributes class];
}

-(instancetype)init {
    if (self = [super init]) {
        lastIndex = NSNotFound;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        lastIndex = NSNotFound;
    }
    return self;
}

-(CGSize)itemSize {
    CGFloat w = self.collectionView.bounds.size.width - (self.collectionView.contentInset.left + self.collectionView.contentInset.right);
    CGFloat h = self.collectionView.bounds.size.height - (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom);
    return (CGSize){w, h};
}

-(void)prepareForAnimatedBoundsChange:(CGRect)oldBounds {
    CGPoint pt = self.collectionView.contentOffset;
    CGFloat w = self.collectionView.bounds.size.width;
    
    lastIndex = (NSInteger)(oldBounds.origin.x / oldBounds.size.width);
}

-(void)prepareLayout {
    [super prepareLayout];
    
    if (lastIndex != NSNotFound) {
        CGPoint pt = self.collectionView.contentOffset;
        CGFloat w = self.collectionView.bounds.size.width;
        
        pt.x = lastIndex * w;
        self.collectionView.contentOffset = pt;
        
        lastIndex = NSNotFound;
    }
}

#pragma mark -

-(void)setContentMode:(UIViewContentMode)contentMode {
    _contentMode = contentMode;
    [self invalidateLayout];
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray <MediaScrollerLayoutAttributes *> *attrs = [super layoutAttributesForElementsInRect:rect];
    [attrs enumerateObjectsUsingBlock:^(MediaScrollerLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentMode = self.contentMode;
    }];
    return attrs;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaScrollerLayoutAttributes *attrs = [super layoutAttributesForItemAtIndexPath:indexPath];
    attrs.contentMode = self.contentMode;
    
    return attrs;
}

@end
