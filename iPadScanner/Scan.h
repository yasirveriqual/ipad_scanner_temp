//
//  Scan.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/21/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "Model.h"
#import "Emergency.h"

@interface Scan : Model

@property (nonatomic, retain) NSString *scanSessionName;
@property (nonatomic, retain) NSString *scanSessionStartDate;
@property (nonatomic, retain) NSString *scanSessionEndDate;
@property (nonatomic, retain) NSString *emergencyId;

@property (nonatomic, retain) Emergency *emergency;
@property (nonatomic, retain) NSMutableArray *employees;

+ (NSArray *)scansFromArray:(NSArray *)scansArray;
@end
