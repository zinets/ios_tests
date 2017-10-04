//
// Created by Zinets Viktor on 10/4/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

// аниматор для фотокропа: "туда" показываем разворачиванием картинки, назад просто сдвигаем картинку вниз
@interface PhotoCropAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) UINavigationControllerOperation operation;
@end