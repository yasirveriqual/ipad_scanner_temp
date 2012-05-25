//
//  EmergencyDropdownViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 12/9/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
// 1

#import <UIKit/UIKit.h>
#import "Emergency.h"
#import "EmergencyTableViewCell.h"
#import "ServiceManager.h"

@protocol EmergencyDropdownViewControllerDelegate
- (void)itemSelected:(Emergency *)item;
@optional
- (void)editEmergency:(Emergency *)emergency;
@end


@interface EmergencyDropdownViewController : UITableViewController <EmergencyTableViewCellDelegate,ServiceManagerDelegate>


@property (nonatomic, retain) ServiceManager *serviceManager;
@property (nonatomic, assign) BOOL isDownloaded;
@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) NSArray *emergencies;
@property (nonatomic, retain) id <EmergencyDropdownViewControllerDelegate> delegate;

@property (readwrite) BOOL canEditEmergency;

- (void)pullEmergenciesFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate;
- (void)pullAllEmergencies;

@end
