//
//  StackLayout.h
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StackLayoutDelegate <NSObject>
@required
- (void)layout:(id)sender didRemoveItemAtIndexpath:(NSIndexPath *)indexPath;
- (void)layout:(id)sender willRestoreItemAtIndexpath:(NSIndexPath *)indexPath;
- (BOOL)hasRemovedItems:(id)sender;
@end

@interface StackLayout : UICollectionViewLayout
@property (nonatomic, weak) id <StackLayoutDelegate> delegate;
/// расстояние в глубину между соседними ячейками; 0,25 по умолчанию из расчета 4 ячейки в стопке (считая самую нижнюю, которая прозрачна до момента начала свайпа)
@property (nonatomic, assign) CGFloat spacing;
@end
