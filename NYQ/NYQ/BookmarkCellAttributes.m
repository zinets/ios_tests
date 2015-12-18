//
//  BookmarkCellAttributes.m
//  Browser
//
//  Created by Zinets Victor on 5/28/15.
//  Copyright (c) 2015 Yarra. All rights reserved.
//

#import "BookmarkCellAttributes.h"

@implementation BookmarkCellAttributes

- (id)copyWithZone:(NSZone *)zone
{
    BookmarkCellAttributes *attributes = [super copyWithZone:zone];
    attributes.editingModeActive = _editingModeActive;
    return attributes;
}

-(BOOL)isEqual:(id)object {
    BOOL res = self.editingModeActive == ((BookmarkCellAttributes *)object).editingModeActive;
    if (!res) {
        return NO;
    } else {
        return [super isEqual:object];
    }
}

@end
