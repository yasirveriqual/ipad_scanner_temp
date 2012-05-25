//
//  DateDropDownTableViewCell.h
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "DatePickerDropdownViewController.h"
#import "DropDownTableViewCell.h"

@protocol DateDropDownTableViewCellDelegate <TableViewCellDelegate>

- (BOOL)dateSelected:(NSDate *)selectedValue forDictionary:(NSDictionary *)dictionary;

@end

@interface DateDropDownTableViewCell : DropDownTableViewCell <DatePickerDropdownViewControllerDelegate>

@property (nonatomic, assign) id <DateDropDownTableViewCellDelegate> delegate;
@property (nonatomic, retain) DatePickerDropdownViewController *dropdownController;

- (IBAction)dropdownButtonClicked;

@end
