//
//  ViewController.m
//  messageTextTest
//
//  Created by Zinets Victor on 2/19/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "InputViewAccessoryView.h"

#import "TextViewWithMentionDetecting.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, InputViewAccessoryViewDelegate, MessageTextStorageDelegate> {
    NSArray *array;
//    MessageTextStorage *storage;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet TextViewWithMentionDetecting *textView;

@property (strong, nonatomic) IBOutlet InputViewAccessoryView *accessoryView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    array = @[
              [MentionedUser userWithName:@"Anna" avatar:@"i0.jpg"],
              [MentionedUser userWithName:@"Amanda" avatar:@"i1.jpg"],
              [MentionedUser userWithName:@"Boris" avatar:@"i2.jpg"],
              [MentionedUser userWithName:@"Cat" avatar:@"i3.jpg"],
              [MentionedUser userWithName:@"Jose" avatar:@"i4.jpg"],
              [MentionedUser userWithName:@"Zaharia" avatar:@"i5.jpg"],
              ];
    
    self.label.text = @"Lorem ipsum @dolor sit er elit lamet, consectetaur cillium @adipisicing pecu, sed @do eiusmod tempor incididunt ut labore et dolore magna.";
    
//    storage = [MessageTextStorage new];
//    [storage addLayoutManager:self.textView.layoutManager];
//    storage.mentionDelegate = self;
//    [storage replaceCharactersInRange:NSMakeRange(0, 0) withString:self.textView.text];
    
    self.textView.mentionDelegate = self;
    
    self.accessoryView.dataSource = nil; //array;
    self.accessoryView.delegate = self;
//    self.textView.inputAccessoryView = self.accessoryView;
    [self registerKeyboard];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.label setNeedsDisplay];
}

#pragma mark table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = @"";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (indexPath.row == 0) {
//        cell.text = self.label.text;
    } else {
        for (int i = 0; i <= indexPath.row; i++) {
            text = [text stringByAppendingFormat:@"%@ ", @"Lorem @ipsum doe"];
        }
        cell.text = text;
    }
    return cell;
}

#pragma mark text

- (void)accessoryView:(id)sender didSelectItemAtIndex:(NSInteger)index {
    MentionedUser *user = self.accessoryView.dataSource[index];
    [self.textView replaceLastMentionWith:user.screenname];
}

- (void)textStorage:(id)sender didFindMention:(NSString *)mention {
    if (mention.length == 0) { // показываем все что есть
        self.accessoryView.dataSource = array;
    } else { // фильтруем; очевидно, что в массиве у обьектов должно быть поле screenname
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[c] %@", @"screenname", mention];
        NSArray *a = [array filteredArrayUsingPredicate:predicate];
        self.accessoryView.dataSource = a;
    }
}

-(void)textStorageHasntMention:(id)sender {
    if (self.accessoryView.dataSource) {
        self.accessoryView.dataSource = nil;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(textView.text);
    
    return YES;
}








- (NSMutableDictionary *)storedConstants {
    static dispatch_once_t onceToken;
    static NSMutableDictionary *dictionary = nil;
    dispatch_once(&onceToken, ^{
        dictionary = [NSMutableDictionary dictionary];
    });
    
    return dictionary;
}

// эта мазафака работает только если мы в сториборде; по крайней мере тогда появляются top- и bottom- layoutGuide, к нижнему из которых привязывается пересчет констрантов
- (NSArray <NSLayoutConstraint *> *)bottomConstraints {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (([constraint.firstItem isEqual:self.bottomLayoutGuide] &&
             constraint.firstAttribute == NSLayoutAttributeTop &&
             constraint.secondAttribute == NSLayoutAttributeBottom) ||
            ([constraint.secondItem isEqual:self.bottomLayoutGuide] &&
             constraint.secondAttribute == NSLayoutAttributeTop &&
             constraint.firstAttribute == NSLayoutAttributeBottom)) {
                [arr addObject:constraint];
            }
    }
    return [arr copy];
}

- (void)registerKeyboard {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSLayoutConstraint *c in self.bottomConstraints) {
        dict[@(c.hash)] = @(c.constant);
    }
    self.storedConstants[@(self.hash)] = dict;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterKeyboard {
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.storedConstants removeObjectForKey:@(self.hash)];
}

- (void)animateKeyboard:(CGFloat)duration options:(UIViewAnimationOptions)options {
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark observing

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *stored = [self storedConstants][@(self.hash)];
    if (stored.count) {
        CGRect frameEnd = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
        for (NSLayoutConstraint *c in self.bottomConstraints) {
            if (stored[@(c.hash)]) {
                CGFloat savedConstant = [stored[@(c.hash)] floatValue];
                c.constant = savedConstant + frameEnd.size.height;
            }
        }
        
        NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationOptions opt = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
        [self animateKeyboard:duration options:opt];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *stored = [self storedConstants][@(self.hash)];
    if (stored.count) {
        for (NSLayoutConstraint *c in self.bottomConstraints) {
            if (stored[@(c.hash)]) {
                CGFloat savedConstant = [stored[@(c.hash)] floatValue];
                c.constant = savedConstant;
            }
        }
        
        NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationOptions opt = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
        [self animateKeyboard:duration options:opt];
    }
}

@end
