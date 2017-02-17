//
//  ViewController.m
//  testImageView
//
//  Created by Zinets Victor on 2/17/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "ImageView.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet ImageView *landscapeView;
@property (weak, nonatomic) IBOutlet ImageView *portraitView;
@property (weak, nonatomic) IBOutlet ImageView *squareView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController {
    NSMutableArray *dataSource;
}

- (IBAction)portraitImageLoad:(id)sender {
    self.landscapeView.image = [UIImage imageNamed:@"ar_less.jpg"];
    self.portraitView.image = [UIImage imageNamed:@"ar_less.jpg"];
    self.squareView.image = [UIImage imageNamed:@"ar_less.jpg"];
}

- (IBAction)landscapeImageLoad:(id)sender {
    self.landscapeView.image = [UIImage imageNamed:@"ar_more.jpg"];
    self.portraitView.image = [UIImage imageNamed:@"ar_more.jpg"];
    self.squareView.image = [UIImage imageNamed:@"ar_more.jpg"];
}

- (IBAction)squareImageLoad:(id)sender {
    self.landscapeView.image = [UIImage imageNamed:@"ar_1.jpg"];
    self.portraitView.image = [UIImage imageNamed:@"ar_1.jpg"];
    self.squareView.image = [UIImage imageNamed:@"ar_1.jpg"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [NSMutableArray array];
    for (int x = 0; x < 19; x++) {
        NSString *fn = [NSString stringWithFormat:@"i%@.jpg", @(x)];
        [dataSource addObject:fn];
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:dataSource[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.landscapeView.image = [UIImage imageNamed:dataSource[indexPath.item]];
    self.portraitView.image = [UIImage imageNamed:dataSource[indexPath.item]];
    self.squareView.image = [UIImage imageNamed:dataSource[indexPath.item]];
}

@end
