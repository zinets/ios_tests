//
//  ViewController.m
//  messageTextTest
//
//  Created by Zinets Victor on 2/19/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.label.text = @"Lorem ipsum @dolor sit er elit lamet, consectetaur cillium @adipisicing pecu, sed @do eiusmod tempor incididunt ut labore et dolore magna.";
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


@end
