//
//  ViewController.m
//  testEndlessStack
//
//  Created by Zinets Victor on 3/7/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "QuizStackLayout.h"
#import "SimpleQuizesCell.h"

@interface ViewController(Quiz) <QuizStackLayoutDataSource, QuizStackLayoutDelegate>
@end

@interface ViewController(Collection)<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *stackView;
@property (weak, nonatomic) IBOutlet QuizStackLayout *stackViewLayout;

@end

@implementation ViewController

- (void)initStack {
    self.stackViewLayout.itemSize = (CGSize){280, 330};
    self.stackViewLayout.userInteractionEnabled = YES;
    self.stackViewLayout.isStackOnTop = NO;
    self.stackViewLayout.quizDataSource = self;
    self.stackViewLayout.quizDelegate = self;

    [self.stackView registerNib:[UINib nibWithNibName:@"SimpleQuizesCell" bundle:nil] forCellWithReuseIdentifier:@"stackCellId"];
    
    [self.stackView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStack];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self initStack];
}




@end

#pragma mark - Quizes

@implementation ViewController(Quiz)

- (BOOL)isHorizontalPanAvailableForIndex:(NSInteger)idx {
    return YES;
}

- (BOOL)isVerticalPanAvailableForIndex:(NSInteger)idx {
    return YES;
}

- (void)topIndexChangedTo:(NSInteger)idx from:(NSInteger)prevIdx withBunchPosition:(QuizStackBunchPosition)bunchPosition {
    
}

- (void)indexWasSkipped:(NSInteger)index {
    
}

@end

#pragma mark - ViewControllerCollection

@implementation ViewController(Collection)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SimpleQuizesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stackCellId" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"stack item #%@", @(indexPath.item)];
    
    return cell;
}

@end
