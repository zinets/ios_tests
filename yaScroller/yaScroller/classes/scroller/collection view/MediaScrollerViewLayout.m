//
//  MediaScrollerViewLayout.m
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "MediaScrollerViewLayout.h"

@implementation MediaScrollerViewLayout

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(CGSize)itemSize {
    return self.collectionView.bounds.size;
}

@end
