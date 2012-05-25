//
//  EmergencyTableViewCell.h
//  iPadScanner
//
//  Created by Adeel Rehman on 12/16/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmergencyTableViewCellDelegate <NSObject>

- (void)editEmergencyAtIndex:(int)_cellIndex;

@end

@interface EmergencyTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblEmergencyName;
@property (nonatomic, assign) id<EmergencyTableViewCellDelegate> delegate;
@property (readwrite) int cellIndex;

@property (nonatomic, retain) IBOutlet UIButton *editButton;

@property (nonatomic, readwrite) BOOL isEditable;

- (IBAction)editBtnClicked:(id)sender;

@end
