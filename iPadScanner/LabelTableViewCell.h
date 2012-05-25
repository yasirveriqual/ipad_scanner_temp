//
//  LabelTableViewCell.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/7/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "TableViewCell.h"

@interface LabelTableViewCell : TableViewCell

@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;

@end
