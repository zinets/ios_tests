//
//  ViewController.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "StackLayout.h"
#import "StackCell.h"

#import "Utils.h"
#import "images.h"



@interface SubItems : NSObject {
    NSMutableArray *intData;
}
- (instancetype)initWithData:(NSArray *)data;
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, readonly) NSMutableArray <NSDictionary *> *items;
@property (nonatomic, assign) NSInteger capacity;

- (void)reset;
@end

@implementation SubItems

-(void)reset {
    self.itemIndex = 0;
}

-(void)setCapacity:(NSInteger)capacity {
    _capacity = capacity;
    [self reset];
}

-(void)setItemIndex:(NSInteger)itemIndex {
    _itemIndex = itemIndex;
    NSInteger maxCount = MIN(intData.count - itemIndex, self.capacity);
    _items = [NSMutableArray arrayWithArray:[intData subarrayWithRange:(NSRange){self.itemIndex, maxCount}]];
}

-(instancetype)initWithData:(NSArray *)data {
    if (self = [super init]) {
        intData = (id)data;
        self.capacity = 4;
    }
    return self;
}

@end

#pragma mark -

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StackLayoutDelegate> {
    SubItems *subItems;
}
@property (nonatomic, strong) StackLayout *listLayout;
@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation ViewController

#define ITEMS_COUNT 6

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *items = [NSMutableArray array];
    
    NSArray *const images_fn = @[
                              @"http://cdn.wdrimg.com/photo/show/id/702f8ac16b504dc39034e38d4507cfc2?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTExLTIzIDExOjMyOjQwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/d088eebd626047e4b9baa991271c8a08?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTI4IDIyOjU4OjMyIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/b97daf789771494296e55760a4fd19c3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/ecae4bb4abcf43b5b2663071c4884629?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/fd69a7a237984a9ebd913beac708a7c8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/b97daf789771494296e55760a4fd19c3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/d088eebd626047e4b9baa991271c8a08?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTI4IDIyOjU4OjMyIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/2c4f528faf374f37ace29ee2f66d5d1c?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/ecae4bb4abcf43b5b2663071c4884629?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/fd69a7a237984a9ebd913beac708a7c8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/ecae4bb4abcf43b5b2663071c4884629?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/333118c71d5540a39e133d44df2f0664?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/fd69a7a237984a9ebd913beac708a7c8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/1be99de113c9489dad8ac27664aa5ca3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/2c4f528faf374f37ace29ee2f66d5d1c?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/ecae4bb4abcf43b5b2663071c4884629?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/5ca4179af08d415e8f59a24ca21557f3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/333118c71d5540a39e133d44df2f0664?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/1be99de113c9489dad8ac27664aa5ca3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/333118c71d5540a39e133d44df2f0664?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/fd69a7a237984a9ebd913beac708a7c8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/1be99de113c9489dad8ac27664aa5ca3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/89ccfc69ad874424954f815791dc0c27?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/5ca4179af08d415e8f59a24ca21557f3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/333118c71d5540a39e133d44df2f0664?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/702f8ac16b504dc39034e38d4507cfc2?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTExLTIzIDExOjMyOjQwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/fd69a7a237984a9ebd913beac708a7c8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/89ccfc69ad874424954f815791dc0c27?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/fd69a7a237984a9ebd913beac708a7c8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/1be99de113c9489dad8ac27664aa5ca3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/89ccfc69ad874424954f815791dc0c27?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/52c7dc6952d6484caca845a37cb109f6?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA1OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/702f8ac16b504dc39034e38d4507cfc2?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTExLTIzIDExOjMyOjQwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/fd69a7a237984a9ebd913beac708a7c8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/72f1187f69ac4189b9f117e1fa89160c?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/1be99de113c9489dad8ac27664aa5ca3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/52c7dc6952d6484caca845a37cb109f6?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA1OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/1be99de113c9489dad8ac27664aa5ca3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/89ccfc69ad874424954f815791dc0c27?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/52c7dc6952d6484caca845a37cb109f6?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA1OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/42a7d98e29534769be12a5962a9681ac?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/72f1187f69ac4189b9f117e1fa89160c?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/840ae6525e62481bbc1718a362452ba2?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/e5f23da64700404aa2b9050357e34ef4?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/1be99de113c9489dad8ac27664aa5ca3?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/914ad6a7eeea47f588740217e839abcd?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/89ccfc69ad874424954f815791dc0c27?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/42a7d98e29534769be12a5962a9681ac?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/89ccfc69ad874424954f815791dc0c27?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/52c7dc6952d6484caca845a37cb109f6?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA1OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/42a7d98e29534769be12a5962a9681ac?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/6ec3c545868f478b9aeb6161622446ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/914ad6a7eeea47f588740217e839abcd?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/89ccfc69ad874424954f815791dc0c27?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/3a5a8c906aba493ea481c4243099a925?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA3OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/52c7dc6952d6484caca845a37cb109f6?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA1OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/6ec3c545868f478b9aeb6161622446ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/52c7dc6952d6484caca845a37cb109f6?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA1OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/42a7d98e29534769be12a5962a9681ac?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/6ec3c545868f478b9aeb6161622446ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9a71c4fb501e4f7880baae0fdd4f4ea9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTE1IDA5OjQyOjE4In0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/3a5a8c906aba493ea481c4243099a925?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA3OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/7a091274b09c49409e47977fa90547fc?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA2OjUyIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/bee84e46e9cb4a88a7f69518448f3bf7?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA2OjEwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/52c7dc6952d6484caca845a37cb109f6?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA3LTE4IDE2OjA1OjIzIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/42a7d98e29534769be12a5962a9681ac?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9a71c4fb501e4f7880baae0fdd4f4ea9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTE1IDA5OjQyOjE4In0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/42a7d98e29534769be12a5962a9681ac?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/6ec3c545868f478b9aeb6161622446ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9a71c4fb501e4f7880baae0fdd4f4ea9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTE1IDA5OjQyOjE4In0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9112ff6f357d4d848b27cbee150963ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/42a7d98e29534769be12a5962a9681ac?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/6ec3c545868f478b9aeb6161622446ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9112ff6f357d4d848b27cbee150963ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/42a7d98e29534769be12a5962a9681ac?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/6ec3c545868f478b9aeb6161622446ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9112ff6f357d4d848b27cbee150963ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/6ec3c545868f478b9aeb6161622446ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9a71c4fb501e4f7880baae0fdd4f4ea9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTE1IDA5OjQyOjE4In0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9112ff6f357d4d848b27cbee150963ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/5cd98150886f4ecb9e94fb67a20a7f5c?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/84a9f2594a3211e39df290b11c05f0b9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/6ec3c545868f478b9aeb6161622446ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/5285f0c23aa348cdb76f9ef7794faf54?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9a71c4fb501e4f7880baae0fdd4f4ea9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTE1IDA5OjQyOjE4In0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/5cd98150886f4ecb9e94fb67a20a7f5c?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9a71c4fb501e4f7880baae0fdd4f4ea9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTE1IDA5OjQyOjE4In0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9112ff6f357d4d848b27cbee150963ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/5cd98150886f4ecb9e94fb67a20a7f5c?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/680b4aecd5a841d9b92bb7521955b16e?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/5285f0c23aa348cdb76f9ef7794faf54?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/daee8c1e0d5e4b3281a9e5fde5ce0aaa?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9a71c4fb501e4f7880baae0fdd4f4ea9?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIyMDE1LTA2LTE1IDA5OjQyOjE4In0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/15eb241cbbe04f11a21351af5d3cbae8?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              @"http://cdn.wdrimg.com/photo/show/id/9112ff6f357d4d848b27cbee150963ef?hash=eyJ0eXBlIjoibm9ybWFsIiwic2l6ZSI6NTAwLCJ1cGRhdGVkT24iOiIwMDAwLTAwLTAwIDAwOjAwOjAwIn0%3D",
                              ];
    
    for (int i = 1; i < ITEMS_COUNT; i++) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
        for (int x = 0; x < 4; x++) {
//            NSString *fn = [NSString stringWithFormat:@"p%ld.jpg", arc4random() % 16];
//            [images addObject:[UIImage imageNamed:fn]];
            NSString *fn = images_fn[i * 4 + x];
            [images addObject:fn];
        }
        NSString *title = [NSString stringWithFormat:@"item #%@", @(i)];
        NSDictionary *d = @{@"title" : title,
                            @"images" : images};
        [items addObject:d];
    }
    subItems = [[SubItems alloc] initWithData:items];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - collection

- (void)registerCells {
    [self.collectionView registerClass:[StackCell class] forCellWithReuseIdentifier:reuseIdStackCell];
}

- (StackLayout *)listLayout {
    if (!_listLayout) {
        _listLayout = [[StackLayout alloc] init];
        _listLayout.delegate = self;
    }
    return _listLayout;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.listLayout];
        [self registerCells];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        borderControl(_collectionView);
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return subItems.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdStackCell forIndexPath:indexPath];
    NSDictionary *d = subItems.items[indexPath.item];
    cell.title = d[@"title"];
    cell.images = d[@"images"];
    
    return cell;
}

#pragma mark - stack

-(void)layout:(id)sender didRemoveItemAtIndexpath:(NSIndexPath *)indexPath {
    subItems.itemIndex++;
}

- (void)layout:(id)sender willRestoreItemAtIndexpath:(NSIndexPath *)indexPath {
    subItems.itemIndex--;    
//    [self.collectionView reloadData];
}

- (BOOL)hasRemovedItems:(id)sender {
    return subItems.itemIndex > 0;
}

@end
