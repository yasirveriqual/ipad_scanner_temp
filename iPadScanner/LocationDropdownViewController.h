//
//  LocationDropdownViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 10/28/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@protocol LocationDropdownViewControllerDelegate
- (void)selectedLocationAtIndex:(NSUInteger)index;
@end



@interface LocationDropdownViewController : UITableViewController

@property (nonatomic, assign) id <LocationDropdownViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *locations;

@end
