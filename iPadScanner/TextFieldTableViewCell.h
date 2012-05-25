//
//  TextFieldTableViewCell.h
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "TableViewCell.h"

@interface TextFieldTableViewCell : TableViewCell <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UITextField *textField;

- (IBAction)valueChanged;

@end
