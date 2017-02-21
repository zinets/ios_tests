//
//  ViewController.m
//  testImageView
//
//  Created by Zinets Victor on 2/17/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewControl.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ControlPullDownProtocol> {
    BOOL fs;
}
@property (weak, nonatomic) IBOutlet ImageViewControl *landscapeView;
@property (weak, nonatomic) IBOutlet ImageViewControl *portraitView;
@property (weak, nonatomic) IBOutlet ImageViewControl *squareView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *emberView;

// фрейм вью, которое переходит в фулцкрин
@property (nonatomic) CGRect lastRect;
// офсеты вью в момент перехода в фулцкрин
@property (nonatomic) CGPoint lastOffset;

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
    ImageViewControl *senderView = nil;
    if ([sender.view isKindOfClass:[ImageViewControl class]]) {
        senderView = sender.view;
    } else{
        return;
    }

    if (!fs) {
        self.lastRect = senderView.frame;
        self.lastOffset = senderView.contentOffset;

        ImageViewControl *fsView = [senderView copy]; // при создании копии скопируются разные офсеты и прочее - для более гладкой анимации
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
            senderView.zoomEnabled = NO;
            senderView.frame = self.lastRect;
            senderView.contentOffset = self.lastOffset;
        } completion:^(BOOL finished) {
            [senderView removeFromSuperview];
        }];
    }
    fs = !fs;
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

- (void)controlReachedPullDownLimit:(ImageViewControl *)sender {
    fs = NO;
    [sender removeFromSuperview];
}

@end
