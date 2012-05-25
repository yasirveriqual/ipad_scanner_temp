//
//  ReportBasicInformationViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/19/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ReportContentViewController.h"
#import "DatePickerDropdownViewController.h"
#import "EmergencyDropdownViewController.h"

@interface ReportBasicInformationViewController : ReportContentViewController    <EmergencyDropdownViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, DatePickerDropdownViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UITextField *startDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *endDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *emergencyTextField;

@property (nonatomic, retain) UIPopoverController *datePopover;
@property (nonatomic, retain) DatePickerDropdownViewController *dateDropdownController;
@property (nonatomic, retain) IBOutlet UIImageView *startDateImageView;
@property (nonatomic, retain) IBOutlet UIImageView *endDateImageView;

@property (nonatomic, retain) UIPopoverController *emergencyPopover;
@property (nonatomic, retain) EmergencyDropdownViewController *emergencyDropdownController;
@property (nonatomic, retain) IBOutlet UIImageView *emergencyImageView;

@property (nonatomic, retain) NSArray *emergencies;
@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) Emergency *selectedEmergency;


@property (nonatomic, retain) IBOutlet UIButton *emergencyButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

@property (nonatomic, retain) NSMutableArray *selectedLocations;


@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)selectStartDate;
- (IBAction)selectEndDate;
- (IBAction)selectEmergency;
- (IBAction)nextClicked;

@end
