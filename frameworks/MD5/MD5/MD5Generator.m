//
//  MD5Generator.m
//  MD5
//
//  Created by Alexandr Dikhtyar on 8/2/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "MD5Generator.h"
#import <CommonCrypto/CommonDigest.h>


@implementation MD5Generator

+ (NSString *)md5:(NSString *)sourceString {
    const char *str = [sourceString UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return result;
}

@end
