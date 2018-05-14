//
// Created by Victor Zinets on 5/14/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HexagonalCollectionDelegate <NSObject>
@required
- (void)hexagonalCollectionView:(UIView *)view didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HexagonCollectionView : UIView
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id <HexagonalCollectionDelegate> delegate;
@end
