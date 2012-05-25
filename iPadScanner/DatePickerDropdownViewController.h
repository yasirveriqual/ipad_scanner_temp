//
//  DatePickerDropdownViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 11/4/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DatePickerDropdownViewControllerDelegate <NSObject>

- (void)dateSelected:(NSDate *)selectedDate;

@end


@interface DatePickerDropdownViewController : UIViewController

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) id <DatePickerDropdownViewControllerDelegate> delegate;

- (IBAction)dateValueChanged:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil textField:(UITextField *)textField;

@end
