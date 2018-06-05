//
//  ViewController.m
//  yaScroller
//
//  Created by Victor Zinets on 6/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "MediaScrollerDatasource.h"

#import "PhotoFromInternet.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) MediaScrollerDatasource *dataSource;

@property (nonatomic, strong) NSArray <PhotoFromInternet *> *testItems;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *a = [@[] mutableCopy];
    [@[
       @"https://www.white-ibiza.com/wp-content/uploads/wellbeing-opener.jpg",
       @"https://ae01.alicdn.com/kf/HTB10Nk9eDnI8KJjy0Ffq6AdoVXar/Ceremokiss-Summer-Sexy-Club-Swimwear-Women-Bikini-Sets-Stripes-Bandage-Swimsuit-Push-Up-Bathing-Suit-Brazilian.jpg",
       @"https://www.dhresource.com/0x0s/f2-albu-g5-M01-8E-87-rBVaI1k-RhKAXE7jAAaagwlQR_4251.jpg/velvet-bikini-2017-sexy-micro-bikinis-women.jpg",
       @"https://www.dhresource.com/albu_226507030_00-1.0x0/halter-dropshipping.jpg",
       @"https://thumbs.dreamstime.com/b/bikini-girl-sitting-seaside-rock-15452009.jpg",
       @"https://i.pinimg.com/originals/c4/81/e0/c481e0eca617af42933ff5a8c747dc67.jpg",
       @"https://cdn0.documentaryheaven.com/wp-content/thumbnails/9251-770x433.jpg",
       @"https://www.glifting.co.uk/wp-content/uploads/2017/03/Glifting-Girls-Ibiza-2017-2-1024x683.jpg",
       @"https://c1.staticflickr.com/5/4109/5447991626_2121c39120_b.jpg",
       
       ] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           PhotoFromInternet *item = [PhotoFromInternet new];
           item.url = obj;
           
           [a addObject:item];
       }];
    self.testItems = [a copy];
    
    self.dataSource = [[MediaScrollerDatasource alloc] init];
    self.dataSource.collectionView = self.collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRefresh:(id)sender {
    self.dataSource.items = [self.testItems subarrayWithRange:(NSRange){0, 3}];
}

- (IBAction)onRemove:(id)sender {
    if (self.dataSource.items.count > 2) {
        NSMutableArray *array = [self.dataSource.items mutableCopy];
        [array removeObjectAtIndex:1];
        
        self.dataSource.items = array;
    }
}

- (IBAction)onAdd:(id)sender {
    NSMutableArray *array = [self.dataSource.items mutableCopy];
    [array addObject:self.testItems[0]];
    self.dataSource.items = array;
}

@end
