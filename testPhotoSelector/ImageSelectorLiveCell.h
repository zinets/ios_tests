//
//  ImageSelectorLiveCell.h
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSelectorLiveCellDelegate <NSObject>
@required
/// ячейка, которая показывает "живые картинки", выбрала :) какую-то картинку - возможно она nil - значит выбрали камеру и надо делать фото
- (void)cell:(UICollectionViewCell *)sender didSelectImage:(UIImage *)image;
@end

@interface ImageSelectorLiveCell : UICollectionViewCell
@property (nonatomic, weak) id <ImageSelectorLiveCellDelegate> delegate;
+ (CGFloat)cellHeight;
@end
