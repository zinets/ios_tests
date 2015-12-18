//
//  CollectionDataSource.h
//  supplTest
//
//  Created by Zinets Victor on 12/15/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchLayout.h"

@protocol CollectionDataSourceProto <NSObject>
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)textForItemAtIndexpath:(NSIndexPath *)indexPath;

@end

@interface CollectionDataSource : NSObject <LayoutDataSource, CollectionDataSourceProto>
@property (nonatomic, assign) BOOL flirtcastVisible;
@property (nonatomic, assign) BOOL headerBannerVisible;
@end
