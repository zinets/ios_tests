//
//  ViewController.m
//  testGridOpti
//
//  Created by Zinets Victor on 2/4/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "Cubes.h"

@interface ViewController () {
    NSMutableArray <NSValue *> *usedFrames;
    Cubes *cubes;
    __weak IBOutlet UITextField *edW;
    __weak IBOutlet UITextField *edH;
    
}

@end

@implementation ViewController

#define spacing 0.0

- (void)viewDidLoad {
    [super viewDidLoad];

    usedFrames = [NSMutableArray array];
    
    cubes = [[Cubes alloc] initWithFrame:(CGRect){{10, 50}, {300, 600}}];
    [self.view addSubview:cubes];
}

- (void)optimize {
    BOOL proceededH = YES;
    BOOL proceededV = YES;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[usedFrames sortedArrayWithOptions:(0) usingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        NSComparisonResult res = NSOrderedSame;
        CGRect f1 = [obj1 CGRectValue];
        CGRect f2 = [obj2 CGRectValue];
        if (f1.origin.y < f2.origin.y) {
            res = NSOrderedAscending;
        } else if (f1.origin.y > f2.origin.y) {
            res = NSOrderedDescending;
        }
        return res;
    }]];
    
    while (proceededH) {
        // horizontal
        proceededH = NO;
        
        for (int x = 0; x < arr.count - 1; x++) {
            CGRect f1 = [arr[x] CGRectValue];
            CGRect f2 = [arr[x + 1] CGRectValue];
            if (f1.origin.y == f2.origin.y &&
                f1.size.height == f2.size.height &&
                f2.origin.x == f1.origin.x + f1.size.width + spacing) {
                
                CGRect newFrame = CGRectUnion(f1, f2);
                arr[x] = [NSValue valueWithCGRect:newFrame];
                [arr removeObjectAtIndex:x + 1];
                
                proceededH = YES;
                break;
            }
        }
    }
    
    arr = [NSMutableArray arrayWithArray:[arr sortedArrayWithOptions:(0) usingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        NSComparisonResult res = NSOrderedSame;
        CGRect f1 = [obj1 CGRectValue];
        CGRect f2 = [obj2 CGRectValue];
        if (f1.origin.x < f2.origin.x) {
            res = NSOrderedAscending;
        } else if (f1.origin.x > f2.origin.x) {
            res = NSOrderedDescending;
        }
        return res;
    }]];
    
    while (proceededV) {
        // vertical
        proceededV = NO;
        for (int x = 0; x < arr.count - 1; x++) {
            CGRect f1 = [arr[x] CGRectValue];
            CGRect f2 = [arr[x + 1] CGRectValue];
            if (f1.origin.x == f2.origin.x &&
                f1.size.width == f2.size.width &&
                f2.origin.y == f1.origin.y + f1.size.height + spacing) {
                
                CGRect newFrame = CGRectUnion(f1, f2);
                arr[x] = [NSValue valueWithCGRect:newFrame];
                [arr removeObjectAtIndex:x + 1];
                
                proceededV = YES;
                break;
            }
        }
    }

    usedFrames = [NSMutableArray arrayWithArray:[arr sortedArrayWithOptions:(0) usingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        NSComparisonResult res = NSOrderedSame;
        CGRect f1 = [obj1 CGRectValue];
        CGRect f2 = [obj2 CGRectValue];
        if (f1.origin.y < f2.origin.y) {
            res = NSOrderedAscending;
        } else if (f1.origin.y > f2.origin.y) {
            res = NSOrderedDescending;
        }
        return res;
    }]];
}

- (CGRect)findRectForSize:(CGSize)newSize inRect:(CGRect)bounds {
    // начинать надо будет не с 0, а с инсетов
    CGRect res = (CGRect){CGPointZero, newSize};
    // в usedFrames уже соптимизированные блоки
    __block CGFloat minHeight = 0; // ну точнее это не высота, а миним. отступ блока от верха в текущем ряду
    [usedFrames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect nextFrame = [obj CGRectValue];
        minHeight = MIN(minHeight, nextFrame.origin.y + nextFrame.size.height);
    }];
    
    return res;
}

- (IBAction)onTap:(id)sender {
    [usedFrames removeAllObjects];
    
    NSValue *f = [NSValue valueWithCGRect:(CGRect){{0, 0}, {3, 3}}];
    [usedFrames addObject:f];
    f = [NSValue valueWithCGRect:(CGRect){{3, 0}, {3, 3}}];
    [usedFrames addObject:f];
    f = [NSValue valueWithCGRect:(CGRect){{0, 3}, {3, 3}}];
    [usedFrames addObject:f];
    f = [NSValue valueWithCGRect:(CGRect){{3, 3}, {3, 2}}];
    [usedFrames addObject:f];
//    f = [NSValue valueWithCGRect:(CGRect){{2, 2}, {2, 2}}];
//    [usedFrames addObject:f];
//    f = [NSValue valueWithCGRect:(CGRect){{4, 2}, {2, 1}}];
//    [usedFrames addObject:f];
//    
//    f = [NSValue valueWithCGRect:(CGRect){{0, 4}, {2, 2}}];
//    [usedFrames addObject:f];
//    f = [NSValue valueWithCGRect:(CGRect){{2, 4}, {2, 2}}];
//    [usedFrames addObject:f];
//    f = [NSValue valueWithCGRect:(CGRect){{4, 3}, {2, 2}}];
//    [usedFrames addObject:f];


    
    
    [self optimize];
    cubes.frames = usedFrames;
    
    NSLog(@"\n%@", usedFrames);
}

- (IBAction)onAdd:(id)sender {
    NSInteger width = [edW.text integerValue];
    NSInteger height = [edH.text integerValue];
    
    
}
- (IBAction)onReset:(id)sender {
    [usedFrames removeAllObjects];
    cubes.frames = usedFrames;
}

@end
