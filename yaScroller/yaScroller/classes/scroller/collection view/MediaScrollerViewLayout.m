//
//  MediaScrollerViewLayout.m
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "MediaScrollerViewLayout.h"

@implementation MediaScrollerViewLayout {
    NSInteger lastIndex;
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

@end
