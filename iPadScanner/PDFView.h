//
//  PDFView.h
//  iPadScanner
//
//  Created by Adeel Rehman on 11/11/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scan.h"

@interface PDFView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) Scan *scan;

@property (nonatomic, retain) IBOutlet UITableView *tblScans;
@property (nonatomic, retain) IBOutlet UILabel *lblSessionName;

@end
