//
//  UIImage+Cache.h
//  MUIControls
//
//  Created by Eugene Zhuk Work on 23.11.15.
//  Copyright © 2015 iCupid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cache)
// возвращает картинку из кеша или новую картинку созданную в createBlock (сохраняет её в кеш и возвращает)
+ (UIImage *)getImageFromCache:(NSString *)cachedImageName andCreateNewIfNotExist:(UIImage * (^)())createBlock;
@end
