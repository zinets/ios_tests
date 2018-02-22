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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, InputViewAccessoryViewDelegate> {
    NSArray *array;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
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
    
    self.accessoryView.dataSource = array;
    self.accessoryView.delegate = self;
    self.textField.inputAccessoryView = self.accessoryView;
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
