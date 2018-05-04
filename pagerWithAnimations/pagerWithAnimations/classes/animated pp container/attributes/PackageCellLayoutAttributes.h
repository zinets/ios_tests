//
//  PackageCellLayoutAttributes.h
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageCellLayoutAttributes : UICollectionViewLayoutAttributes
/// growing percent - ячейка растет от минимального (0% - 180 px, 100% - 244 px, но это диз с 4.7") к максимальному размеру
@property (nonatomic) CGFloat growingPercent;
@end
