//
//  ViewController.m
//  yaScroller
//
//  Created by Victor Zinets on 6/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "MediaScrollerView.h"

#import "PhotoFromInternet.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MediaScrollerView *collectionView;

@property (nonatomic, strong) NSArray <PhotoFromInternet *> *testItems;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;






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
       @"https://www.glifting.co.uk/wp-content/uploads/2017/03/Glifting-Girls-Ibiza-2017-2-1024x683.jpg",
       @"https://c1.staticflickr.com/5/4109/5447991626_2121c39120_b.jpg",
       
       ] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           PhotoFromInternet *item = [PhotoFromInternet new];
           item.url = obj;
           
           [a addObject:item];
       }];
    self.testItems = [a copy];

    self.collectionView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.oneElementPaginating = YES;
    self.collectionView.paginating = YES;
    self.collectionView.endlessScrolling = NO;
    self.collectionView.tapToScroll = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRefresh:(id)sender {
    self.collectionView.items = [self.testItems subarrayWithRange:(NSRange){0, 3}];
}

- (IBAction)onRemove:(id)sender {
    if (self.collectionView.items.count > 2) {
        NSMutableArray *array = [self.collectionView.items mutableCopy];
        [array removeObjectAtIndex:1];
        
        self.collectionView.items = array;
    }
}

- (IBAction)onAdd:(id)sender {
    NSMutableArray *array = [self.collectionView.items mutableCopy];
    id obj = self.testItems[arc4random_uniform(self.testItems.count)];
    while (YES) {
        if (![array containsObject:obj]) {
            [array addObject:obj];
            break;
        }
        obj = self.testItems[arc4random_uniform(self.testItems.count)];
    }

    self.collectionView.items = array;
}

- (IBAction)onFS:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.navigationController setNavigationBarHidden:sender.selected animated:YES];

    [self.view layoutIfNeeded];
//    self.dataSource.fs = sender.selected;
    [UIView animateWithDuration:0.4 animations:^{


        if (sender.selected) {
            self.leftOffset.constant =
            self.rightOffset.constant =
            self.topOffset.constant =
            self.bottomOffset.constant = 0;
        } else {
            self.leftOffset.constant =
            self.rightOffset.constant = 16;
            self.topOffset.constant = 167;
            self.bottomOffset.constant = 213;
        }

        [self.view layoutIfNeeded];
    }];
}

@end
