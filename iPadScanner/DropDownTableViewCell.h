//
//  DropDownTableViewCell.h
//  
//
//  Created by Yasir Ali on 12/7/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "TextFieldTableViewCell.h"
#import "ItemDropdownViewController.h"

@interface DropDownTableViewCell : TextFieldTableViewCell <ItemDropdownViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *dropdownButton;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) ItemDropdownViewController *dropdownController;

@property (nonatomic, retain) NSArray *source;

@property (nonatomic, readonly) NSUInteger selectedIndex;

- (IBAction)dropdownButtonClicked;
- (void)reloadItems;

@end
