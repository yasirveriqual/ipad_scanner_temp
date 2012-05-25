//
//  TableViewCell.h
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewCellDelegate <NSObject>

@end

@interface TableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *textLabel;

@property (nonatomic, assign) id<TableViewCellDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *dictionary;

@end
