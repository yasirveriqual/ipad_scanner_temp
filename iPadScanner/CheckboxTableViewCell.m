//
//  CheckboxTableViewCell.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/21/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "CheckboxTableViewCell.h"

@implementation CheckboxTableViewCell
@synthesize checkboxButton;
@synthesize delegate;


- (IBAction)checkboxButtonClicked   {
    checkboxButton.selected = !checkboxButton.selected;
    [delegate checkBoxTableViewCell:self didSelected:checkboxButton.selected];
}

@end
