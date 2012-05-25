//
//  ReportScanSessionsViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/23/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ReportContentViewController.h"
@interface ReportScanSessionsViewController : ReportContentViewController  <UITabBarDelegate, UITableViewDataSource,  UIAlertViewDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *previewButton;

@property (nonatomic, retain) NSArray *emails;
@property (nonatomic, retain) NSArray *locations;

@property (nonatomic, retain) NSMutableArray *selectedScans;

@property (nonatomic, retain) NSArray *scans;

- (id)initWithLocations:(NSArray *)locations;
- (id)initWithEmails:(NSArray *)emails;

- (IBAction)previewClicked;

@end
