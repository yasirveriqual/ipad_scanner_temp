//
//  EmergencyTableViewCell.m
//  iPadScanner
//
//  Created by Adeel Rehman on 12/16/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "EmergencyTableViewCell.h"

@implementation EmergencyTableViewCell

@synthesize lblEmergencyName, delegate, cellIndex, isEditable, editButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsEditable:(BOOL)value   {
    isEditable = value;
    editButton.hidden = !isEditable;
}

- (IBAction)editBtnClicked:(id)sender {
    [delegate editEmergencyAtIndex:self.cellIndex];
}

@end
