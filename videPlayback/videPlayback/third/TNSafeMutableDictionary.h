//
//  TNSafeMutableDictionary.h
//  TNCache
//
//  Created by Eugene Zhuk Work on 05.10.15.
//  Copyright © 2015 yarra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNSafeMutableDictionary : NSObject
@property (readonly, copy) NSArray *allKeys;
@property (readonly, copy) NSArray *allValues;

- (id)objectForKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block;

@end
