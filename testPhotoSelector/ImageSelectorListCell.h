//
//  ImageSelectorListCell.h
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSelectorListCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIView *separator;
@property (nonatomic, strong) UIImage *iconImage;

+ (CGFloat)cellHeight;
@end
