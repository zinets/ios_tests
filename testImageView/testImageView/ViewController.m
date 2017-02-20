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

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ControlPullDownProtocol> {
    BOOL fs;
}
@property (weak, nonatomic) IBOutlet ImageView *landscapeView;
@property (weak, nonatomic) IBOutlet ImageView *portraitView;
@property (weak, nonatomic) IBOutlet ImageView *squareView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *emberView;

@property (nonatomic) CGRect lastRect;

@end

// не на иФоне7 нифига не влезет!

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
    
    UITapGestureRecognizer *tapR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    UITapGestureRecognizer *tapR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    UITapGestureRecognizer *tapR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];

    [self.landscapeView addGestureRecognizer:tapR1];
    [self.portraitView addGestureRecognizer:tapR2];
    [self.squareView addGestureRecognizer:tapR3];

    self.pullDownLimit = 120;
}

#pragma mark - delegates

- (void)onTap:(UITapGestureRecognizer *)sender {

    if (!fs) {
        self.lastRect = sender.view.frame;

        ImageView *fsView = [[ImageView alloc] initWithFrame:self.lastRect];
        fsView.image = ((ImageView *)sender.view).image;
        fsView.pullDownDelegate = self;
        [self.emberView addSubview:fsView];

        [UIView animateWithDuration:0.3 animations:^{
            fsView.frame = self.emberView.bounds;
            fsView.zoomEnabled = YES;
        } completion:^(BOOL finished) {
            UITapGestureRecognizer *fsExit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            [fsView addGestureRecognizer:fsExit];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.frame = self.lastRect;
            ((ImageView *)sender.view).zoomEnabled = NO;
        } completion:^(BOOL finished) {
            [sender.view removeFromSuperview];
        }];
    }
    fs = !fs;

    return;


    [UIView animateWithDuration:0.3 animations:^{
        if (!fs) {
            self.lastRect = sender.view.frame;
            sender.view.frame = self.emberView.bounds;
        } else {
            sender.view.frame = self.lastRect;
        }

        [self.emberView bringSubviewToFront:sender.view];

        fs = !fs;
        ((ImageView *)sender.view).zoomEnabled = fs;
    }];
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

- (void)controlReachedPullDownLimit:(ImageView *)sender {
    fs = NO;
    [sender removeFromSuperview];
}

@end
