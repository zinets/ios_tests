//
//  BasePager.h
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePager : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSArray *_dataSource;
}
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray *dataSource;
- (void)startAnimating;
- (void)stopAnimating;
@end
