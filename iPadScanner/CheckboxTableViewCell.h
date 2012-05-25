//
//  CheckboxTableViewCell.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/21/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "TableViewCell.h"

@protocol CheckboxTableViewCellDelegate <NSObject>

- (void)checkBoxTableViewCell:(id)checkboxTableViewCell didSelected:(BOOL)yesOrNo;

@end


@interface CheckboxTableViewCell : TableViewCell

@property (nonatomic, retain) IBOutlet UIButton *checkboxButton;

@property (nonatomic, assign) id <CheckboxTableViewCellDelegate> delegate;

- (IBAction)checkboxButtonClicked;

@end


