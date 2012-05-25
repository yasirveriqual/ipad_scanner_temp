//
//  ReportPreviewViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 2/14/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "ReportContentViewController.h"

@interface ReportPreviewViewController : ReportContentViewController	<UITabBarDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic, retain) NSArray *scanSessionIds;
@property (nonatomic, retain) NSArray *scanSessions;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *recordCountLabel;
@property (nonatomic, retain) IBOutlet UIView *tableContentView;

@property (nonatomic, retain) IBOutlet UIButton *submitButton;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;

@property (nonatomic, retain) UIAlertView *statusAlertView;


- (id)initWithScanSessionIds:(NSArray *)scanSessionIds;


- (IBAction)submitClicked;

@end
