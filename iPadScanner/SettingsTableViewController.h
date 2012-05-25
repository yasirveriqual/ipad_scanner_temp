//
//  SettingsTableViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/27/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "DropDownTableViewCell.h"
#import "DateDropDownTableViewCell.h"

@interface SettingsTableViewController : UITableViewController  <DateDropDownTableViewCellDelegate>{
    DropDownTableViewCell *distanceDropDownTableViewCell;
    TableViewCell *getBaseLocationTableViewCell;
    
    DateDropDownTableViewCell *fromDateDropDownTableViewCell;
    DateDropDownTableViewCell *toDateDropDownTableViewCell;
	
	DropDownTableViewCell *deviceDropDownTableViewCell;
    
    NSArray *locations;
}

@end
