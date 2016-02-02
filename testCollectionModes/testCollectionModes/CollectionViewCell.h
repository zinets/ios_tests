//
//  CollectionViewCell.h
//  testCollectionModes
//
//  Created by Zinets Victor on 1/29/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell {
    UIImageView *_photoView;
}
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *photo;
@end

@interface CollectionViewCellExt : CollectionViewCell
@end