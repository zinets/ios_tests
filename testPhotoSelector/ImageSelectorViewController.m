//
//  ImageSelectorViewController.m
//
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ImageSelectorViewController.h"

#import "ImageSelectorListCell.h"
#import "ImageSelectorLiveCell.h"

#define SELECTOR_LIVE_CELL_ID @"lvclid"
#define SELECTOR_LIST_CELL_ID @"lstclid"

#define ImageSourceTypeCancel ImageSourceTypeCount

@interface SelectorItem : NSObject {}
@property (nonatomic) ImageSourceType itemType;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) UIImage *itemIco;
@property (nonatomic, readonly) NSString *itemCellReuseId;
@end

@implementation SelectorItem

-(NSString *)itemCellReuseId {
    switch (_itemType) {
        case ImageSourceTypeLive:
            return SELECTOR_LIVE_CELL_ID;
        default:
            return SELECTOR_LIST_CELL_ID;
    }
}

@end

@interface ImageSelectorViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray <SelectorItem *> *items;

@property (nonatomic, strong) UICollectionView *table;
@end

@implementation ImageSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor magentaColor];
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self initUI];
}

- (void)onTapAction:(id)sender {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - internal

-(NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray arrayWithCapacity:ImageSourceTypeCount];
    }
    return _items;
}

- (void)initUI {
    if (self.delegate) {
        [self.items removeAllObjects];
        for (ImageSourceType is = ImageSourceTypeLive; is < ImageSourceTypeCount; is++) {
            if ([self.delegate imageSelector:self supportsSourcetype:is]) {
                SelectorItem *newItem = [SelectorItem new];
                newItem.itemType = is;
                newItem.itemTitle = [self.delegate imageSelector:self titleForSourceType:is];
                NSAssert(newItem.itemTitle != nil, @"List item without title has no sense!");
                if ([self.delegate respondsToSelector:@selector(imageSelector:iconForSourceType:)]) {
                    newItem.itemIco = [self.delegate imageSelector:self iconForSourceType:is];
                }
                
                [self.items addObject:newItem];
            }
        }
        
        // отдельно пусть будет cancel
        SelectorItem *cancelItem = [SelectorItem new];
        // это не очень (очень не) правильно, зато просто? или надо дать возможность настроить кнопку cancel?
        cancelItem.itemType = ImageSourceTypeCancel;
#warning Localize me
        cancelItem.itemTitle = @"Cancel";
        [self.items addObject:cancelItem];
        
        CGFloat const cellHeight = 60;
        CGFloat tableHeight = self.items.count * cellHeight;
        CGRect tableFrame = (CGRect){{0, self.view.bounds.size.height - tableHeight}, {self.view.bounds.size.width, tableHeight}};
        
        UICollectionViewFlowLayout *tableLayout = [UICollectionViewFlowLayout new];
        tableLayout.itemSize = (CGSize){self.view.bounds.size.width, cellHeight};
        tableLayout.minimumLineSpacing = 0;
        tableLayout.minimumInteritemSpacing = 0;
        tableLayout.sectionInset = UIEdgeInsetsZero;
        
        _table = [[UICollectionView alloc] initWithFrame:tableFrame collectionViewLayout:tableLayout];
        _table.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        _table.backgroundColor = [UIColor whiteColor];
        
        [_table registerClass:[ImageSelectorListCell class] forCellWithReuseIdentifier:SELECTOR_LIST_CELL_ID];
        [_table registerClass:[ImageSelectorLiveCell class] forCellWithReuseIdentifier:SELECTOR_LIVE_CELL_ID];
        
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [self.table reloadData];
    }
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.items[indexPath.row].itemType) {
        case ImageSourceTypeLive: {
            NSString *reuseId = self.items[indexPath.row].itemCellReuseId;
            ImageSelectorLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
            return cell;  
        } break;
        default: {
            NSString *reuseId = self.items[indexPath.row].itemCellReuseId;
            ImageSelectorListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
            cell.textLabel.text = self.items[indexPath.row].itemTitle;
            cell.iconImage = self.items[indexPath.row].itemIco;
            return cell;
        } break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.items[indexPath.row].itemType == ImageSourceTypeCancel) {
        if (self.delegate) {
            [self.delegate imageSelector:self didFinishWithResult:nil];
        }
    } else {
        
    }
}

@end
