//
//  ItemDropdownViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/7/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemDropdownViewControllerDelegate <NSObject>

- (void)itemSelected:(NSString *)selectedValue;

@end

@interface ItemDropdownViewController : UITableViewController

@property (nonatomic, assign) id <ItemDropdownViewControllerDelegate> delegate;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) NSArray *source;
@property (nonatomic, retain) UIPopoverController *popoverController;

- (id)initWithTextField:(UITextField *)textField;


@end
