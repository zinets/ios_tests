//
//  ViewController.m
//  NYQ
//
//  Created by Zinets Victor on 12/18/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "PageLayout.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, PageLayoutProto> {
    UICollectionView *_collection;
    NSMutableArray <UIImage *>*slices;
}
//@property (nonatomic) NSInteger
@end

#define CELL_ID @"cell"

#warning добавить по тапу что-то - например пожелания

@implementation ViewController

#pragma mark - images loading

- (UIImage *)croppedImage:(CGRect)bounds from:(UIImage *)source{
    CGImageRef imageRef = CGImageCreateWithImageInRect([source CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)loadImage:(NSString *)fn {
    UIImage *img = [UIImage imageNamed:fn];
    
    CGSize sz = img.size;
    CGSize destSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(destSize, YES, 0);
    
    CGFloat hRatio = destSize.width / sz.width;
    CGFloat vRatio = destSize.height / sz.height;
    CGPoint origin = CGPointZero;
    if (hRatio < vRatio) {
        sz = CGSizeApplyAffineTransform(sz, CGAffineTransformMakeScale(vRatio, vRatio));
        origin.x = (destSize.width - sz.width) / 2;
    } else {
        sz = CGSizeApplyAffineTransform(sz, CGAffineTransformMakeScale(hRatio, hRatio));
        origin.y = (destSize.height - sz.height) / 2;
    }
    [img drawInRect:(CGRect){origin, sz}];
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}

- (void)fillImages {
    slices = [NSMutableArray arrayWithCapacity:12];
    UIImage *srcImage = [self loadImage:@"calendar-2016.jpg"];
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 3; x++) {
            CGRect frm = (CGRect){{x * 512, y * 512}, {512, 512}};
            [slices addObject:[self croppedImage:frm from:srcImage]];
        }
    }
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fillImages];
    
    PageLayout *layout = [PageLayout new];
    layout.delegate = self;
    
    _collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collection];
    
    [_collection registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CELL_ID];
    _collection.dataSource = self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}

#pragma mark - collection

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];

    cell.image = slices[indexPath.item];
    
    return cell;
}

#pragma mark - moving delegation

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath
           toIndexPath:(NSIndexPath *)toIndexPath {
    return YES;
}

/// ячейки поменялись местами - нужно обновить датасорс
- (void)collectionView:(UICollectionView *)collectionView
     didMoveItemAtPath:(NSIndexPath *)fromIndex
                toPath:(NSIndexPath *)toIndex {
    UIImage *fromImage = slices[fromIndex.item];
    [slices removeObject:fromImage];
    [slices insertObject:fromImage atIndex:toIndex.item];
}

- (void)wasTapAt:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [_collection cellForItemAtIndexPath:indexPath];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    cell.layer.zPosition = 100;
    
    CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    transform.m34 = 1.0 / 800.0;
    
    [animation setToValue:[NSValue valueWithCATransform3D:transform]];
    [animation setDuration:.75];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setFillMode:kCAFillModeForwards];
    [animation setAutoreverses:YES];
    [animation setRemovedOnCompletion:YES];
    [animation setDelegate:self];
    
    [cell.layer addAnimation:animation forKey:@"test"];
}


@end
