//
//  HTTPRequest.h
//  iPadScanner
//
//  Created by Adeel Rehman on 11/14/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
// //

#import "Model.h"


@interface HTTPRequest : NSMutableURLRequest

@property (nonatomic, retain) NSString *apiName;
@property (nonatomic, retain) Model *object;

@end
