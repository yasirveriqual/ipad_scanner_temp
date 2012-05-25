//
//  TableView.h
//  iPadScanner
//
//  Created by Adeel on 1/18/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewDelegate <NSObject>

- (void)tableViewDidFinishLoading;

@end

@interface TableView : UITableView

@property (nonatomic, assign) IBOutlet id<TableViewDelegate> tableViewDelegate;

@end
