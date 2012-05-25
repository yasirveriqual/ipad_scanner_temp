//
//  ButtonTableViewCell.h
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "TableViewCell.h"

@interface ButtonTableViewCell : TableViewCell

@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction)buttonClicked:(UIButton *)sender;

@end
