//
//  ReportOfficersViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/23/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ReportContentViewController.h"

@interface ReportOfficersViewController : ReportContentViewController  <UITabBarDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *officers;
@property (nonatomic, retain) NSArray *locations;

@property (nonatomic, retain) NSMutableArray *selectedOfficers;

@property (nonatomic, retain) IBOutlet UIButton *nextButton;


- (id)initWithLocations:(NSArray *)locations;

- (IBAction)nextClicked;

@end
