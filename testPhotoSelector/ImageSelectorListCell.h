//
//  ImageSelectorListCell.h
//  testPhotoSelector
//
//  Created by Zinets Victor on 9/28/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSelectorListCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIView *separator;
@property (nonatomic, strong) UIImage *iconImage;
@end
