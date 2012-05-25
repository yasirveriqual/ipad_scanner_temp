//
//  ScansView.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/19/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeTableViewCell.h"
#import "Scan.h"
#import "TableView.h"

@protocol ScanDetailViewDelegate <NSObject>

- (void)scansViewDidSearchRfid:(NSString *)rfid;

@end


@interface ScanDetailView : UIView   <UITableViewDelegate, UITableViewDataSource, EmployeeTableViewDelegate, TableViewDelegate> 

@property (nonatomic, retain) IBOutlet UILabel *scanName;
@property (nonatomic, retain) IBOutlet TableView *employeesTableView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, assign) id <ScanDetailViewDelegate> delegate;
@property (nonatomic, retain) EmployeeTableViewCell *currentEmployeeTableViewCell;

@property (nonatomic, retain) Scan *scan;
- (void)addEmployee:(Employee *)employee;

- (void)changeOrientationToLandscape:(BOOL)yesOrNo;

- (void)setRfid:(NSString *)rfid;

@end
