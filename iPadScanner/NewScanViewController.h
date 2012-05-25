//
//  NewScanViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 10/21/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerDropdownViewController.h"
#import "EmergencyDropdownViewController.h"
#import "NewEmergencyViewController.h"
#import "ViewController.h"
#import "Emergency.h"
#import "Scan.h"

@protocol NewScanViewControllerDelegate <NSObject>
- (void)reloadScans;
@end

@interface NewScanViewController : ViewController <EmergencyDropdownViewControllerDelegate, NewEmergencyViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UILabel *lblTitleText;
@property (nonatomic, retain) IBOutlet UIButton *btnSave;
@property (nonatomic, retain) IBOutlet UIView *innerView;

@property (nonatomic, assign) id <NewScanViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *scanSessionNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *startDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *endDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *emergencyTextField;

@property (nonatomic, retain) IBOutlet UIImageView *imgStartDate;
@property (nonatomic, retain) IBOutlet UIImageView *imgEndDate;
@property (nonatomic, retain) IBOutlet UIImageView *imgEmergency;

@property (nonatomic, retain) UIPopoverController *datePopover;
@property (nonatomic, retain) DatePickerDropdownViewController *dateDropdownController;

@property (nonatomic, retain) UIPopoverController *emergencyPopover;
@property (nonatomic, retain) EmergencyDropdownViewController *emergencyDropdownController;

@property (nonatomic, retain) NSMutableArray *emergencyList;
@property (nonatomic, retain) Emergency *selectedEmergency;

@property (nonatomic, retain) Scan *scanModel;

@property (readwrite) BOOL editDataFlag;


- (IBAction)selectEmergency:(id)sender;
- (IBAction)selectStartDate:(id)sender;
- (IBAction)selectEndDate:(id)sender;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)addClicked:(id)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scanModel:(Scan *)_scan;

@end
