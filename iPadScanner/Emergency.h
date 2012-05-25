//
//  Emergency.h
//  iPadScanner
//
//  Created by Adeel Rehman on 12/9/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "Model.h"

@interface Emergency : Model

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

@end
