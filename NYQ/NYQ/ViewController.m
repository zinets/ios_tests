//
//  ViewController.m
//  NYQ
//
//  Created by Zinets Victor on 12/18/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+Geometry.h"

#import "PageLayout.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, PageLayoutProto> {
    UICollectionView *_collection;
    PageLayout *layout;
    NSMutableArray <NSDictionary <NSNumber *, UIImage *>*>*slices;
}
@property (nonatomic) NSInteger cols;
@property (nonatomic) NSInteger rows;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic) BOOL mixedMode;
@end

#define CELL_ID @"cell"

#warning добавить по тапу что-то - например пожелания

NSInteger const codeLength = 4;
CGPoint const points[codeLength] = {(CGPoint){256 - 100, 256 - 50},
    (CGPoint){512 - 50, 512 - 100},
    (CGPoint){256 - 50, 768 - 50},
    (CGPoint){768 - 100, 768 - 50}};

NSInteger code[codeLength] = {3, 7, 1, 5};

@implementation ViewController

#pragma mark - images loading

- (UIImage *)croppedImage:(CGRect)bounds from:(UIImage *)source{
    CGImageRef imageRef = CGImageCreateWithImageInRect([source CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)loadImage:(NSString *)fn{
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
    
    if (self.mixedMode) {
        UIFont *font = [UIFont fontWithName:@"Herculanum" size:80]; //[UIFont boldSystemFontOfSize:48];
        UIColor *clr = [UIColor blackColor];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        NSDictionary *dict = @{NSFontAttributeName : font,
                               NSForegroundColorAttributeName : clr,
                               NSParagraphStyleAttributeName : style};
        
        for (int x = 0; x < 4; x++) {
            CGPoint pt = points[x];
            CGRect rect = (CGRect){pt, {100, 100}};
            UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithOvalInRect:rect];
            [[UIColor yellowColor] setFill];
            [rectanglePath fill];
            
            pt.y = (CGRectGetMidY(rect) - (font.lineHeight / 2));
            [[NSString stringWithFormat:@"%@", @(code[x])] drawInRect:(CGRect){pt, {100, 100}} withAttributes:dict];
        }
    }
    
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return res;
}

- (void)fillImages:(NSString *)imageName {
    slices = [NSMutableArray arrayWithCapacity:self.cols * self.rows];
    UIImage *srcImage = [self loadImage:imageName];
    CGFloat w = ([UIScreen mainScreen].bounds.size.width / self.cols) * [UIScreen mainScreen].scale;
    CGFloat h = ([UIScreen mainScreen].bounds.size.height / self.rows) * [UIScreen mainScreen].scale;
    CGSize csz = (CGSize){w, h};
    NSInteger count = self.cols * self.rows;
    for (int y = 0; y < self.rows; y++) {
        for (int x = 0; x < self.cols; x++) {
            CGRect frm = (CGRect){{x * csz.width, y * csz.height}, csz};
            NSInteger index = x + self.cols * y;
            NSDictionary *obj = @{@(index) : [self croppedImage:frm from:srcImage]};
            if (self.mixedMode) {
                [slices insertObject:obj atIndex:0];
            } else {
                [slices addObject:obj];
            }
        }
    }
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    _cols = 3;
    _rows = 4;
    
    self.imageName = @"Beautiful-Christmas-Tree-Wallpapers-7.jpg";
    [self fillImages:self.imageName];
    
    layout = [PageLayout new];
    CGFloat w = [UIScreen mainScreen].bounds.size.width / self.cols;
    CGFloat h = [UIScreen mainScreen].bounds.size.height / self.rows;

    layout.itemSize = (CGSize){w, h};
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(swapCells:) userInfo:nil repeats:NO];
}

- (void)swapCells:(id)sender {
    self.mixedMode = YES;
    [self fillImages:self.imageName];
    [_collection reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - setters

- (void)updateLayoutSize {
    CGFloat w = [UIScreen mainScreen].bounds.size.width / self.cols;
    CGFloat h = [UIScreen mainScreen].bounds.size.height / self.rows;
    
    layout.itemSize = (CGSize){w, h};
    [self fillImages:self.imageName];
    [_collection reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

-(void)setCols:(NSInteger)cols {
    if (cols != _cols) {
        _cols = cols;
        [self updateLayoutSize];
    }
}

-(void)setRows:(NSInteger)rows {
    if (rows != _rows) {
        _rows = rows;
        [self updateLayoutSize];
    }
}

#pragma mark - collection

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return slices.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];

    cell.image = [[slices[indexPath.item] allValues] firstObject];
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
    NSDictionary *fromImage = slices[fromIndex.item];
    [slices removeObject:fromImage];
    [slices insertObject:fromImage atIndex:toIndex.item];
    
    [self checkForFinish];
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

#pragma mark -

- (void)delayedUpdate {
    [self playJingleBell];
    self.mixedMode = NO;
    [self fillImages:self.imageName];
    [_collection reloadSections:[NSIndexSet indexSetWithIndex:0]];
    _collection.userInteractionEnabled = NO;
    for (int x = 0; x < 4; x++) {
        CGPoint pt = points[x];
        CGRect rect = (CGRect){pt, {100, 100}};
        UILabel *v = [[UILabel alloc] initWithFrame:rect];
        v.layer.cornerRadius = 50;
        v.clipsToBounds = YES;
        v.backgroundColor = [UIColor yellowColor];
        UIFont *font = [UIFont fontWithName:@"Herculanum" size:80];
        v.font = font;
        v.textColor = [UIColor blackColor];
        v.textAlignment = NSTextAlignmentCenter;
        v.text = [NSString stringWithFormat:@"%@", @(code[x])];
        [_collection addSubview:v];
        
        [UIView animateWithDuration:0.35 + x * 0.1
                              delay:0
             usingSpringWithDamping:4
              initialSpringVelocity:7
                            options:0
                         animations:^{
                             CGFloat d = _collection.width / 4;
                             v.centerX = d / 2 + d * x;
                             v.centerY = _collection.height / 2;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
}

- (void)checkForFinish {
    BOOL solved = YES;
    for (int x = 0; x < slices.count; x++) {
        NSDictionary <NSNumber *, id>*obj = slices[x];
        NSNumber *index = [[obj allKeys] firstObject];
        solved &= [index intValue] == x;
        if (!solved) {
            break;
        }
    }
    if (solved) {
        [self performSelector:@selector(delayedUpdate) withObject:nil afterDelay:0.5];
    }
}

-(void)playJingleBell {
    CFBundleRef mainBundle = CFBundleGetMainBundle(); /* Define mainBundle as the current app's bundle */
    CFURLRef fileURL = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"jingleBell", CFSTR("wav"), NULL); /* Set Bundle as Main Bundle, Define Sound Filename, Define Sound Filetype */
    UInt32 soundID; /* define soundID as a 32Bit Unsigned Integer */
    AudioServicesCreateSystemSoundID (fileURL, &soundID); /* Assign Sound to SoundID */
    AudioServicesPlaySystemSound(soundID); /* Now play the sound associated with this sound ID */
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
