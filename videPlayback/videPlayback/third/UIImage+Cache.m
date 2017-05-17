//
//  UIImage+Cache.m
//  MUIControls
//
//  Created by Eugene Zhuk Work on 23.11.15.
//  Copyright © 2015 iCupid. All rights reserved.
//

#import "UIImage+Cache.h"
#import "TNCache.h"

@implementation UIImage (Cache)
+ (UIImage *)getImageFromCache:(NSString *)cachedImageName andCreateNewIfNotExist:(UIImage * (^)())createBlock {
    UIImage *image = [[UIImage alloc] initWithData:[TNCache dataForKey:cachedImageName] scale:[[UIScreen mainScreen] scale]];
    if (image == nil) {
        if (createBlock) {
            image = createBlock();
            [TNCache setData:UIImagePNGRepresentation(image) forKey:cachedImageName];
        }
    }
    return image;
}
@end
