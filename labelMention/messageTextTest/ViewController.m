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

@interface MessageStorage : NSTextStorage {
    NSMutableAttributedString *storage;
}

@end

@implementation MessageStorage

- (id)init {
    if (self = [super init]) {
        storage = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string {
    return storage.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [storage attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [storage replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [storage setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

- (void)processEditing {
    [super processEditing];
}

@end

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, InputViewAccessoryViewDelegate> {
    NSArray *array;
    MessageStorage *storage;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;

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
    
//    storage = [MessageStorage new];
//    [storage addLayoutManager:self.textView.layoutManager];
    
    self.accessoryView.dataSource = array;
    self.accessoryView.delegate = self;
    self.textView.inputAccessoryView = self.accessoryView;
    
    
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
        cell.text = self.label.text;
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
    NSLog(@"!");
}

@end
