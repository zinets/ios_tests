//
//  ImageProcessor.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/23/18.
//  Copyright © 2018 TN. All rights reserved.
//

@import Foundation;
@import UIKit;

@protocol ImageProcessor <NSObject>

+ (UIImage *)processImage:(UIImage *)image;

@end
