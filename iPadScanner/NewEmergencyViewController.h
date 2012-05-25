//
//  NewEmergencyViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerDropdownViewController.h"
#import "ViewController.h"
#import "Emergency.h"

@protocol NewEmergencyViewControllerDelegate
- (void)loadEmergencies;
@end


@interface NewEmergencyViewController : ViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnSave;

@property (nonatomic, assign) id <NewEmergencyViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;

@property (nonatomic, retain) IBOutlet UITextField *emergencyTextField;
@property (nonatomic, retain) IBOutlet UITextField *startDateTextField;

@property (nonatomic, retain) IBOutlet UIImageView *imgStartDate;

@property (nonatomic, retain) UIPopoverController *datePopover;
@property (nonatomic, retain) DatePickerDropdownViewController *dateDropdownController;

@property (nonatomic, retain) Emergency *emergencyModel;
@property (readwrite) BOOL editDataFlag;

- (IBAction)selectStartDate:(id)sender;
- (IBAction)saveBtnClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil emergencyModel:(Emergency *)_emergency;

@end
