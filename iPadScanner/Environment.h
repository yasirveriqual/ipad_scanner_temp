//
//  Environment.h
//  iPadScanner
//
//  Created by Yasir Ali on 4/19/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Environment : NSObject

@property (nonatomic, retain) NSURL *serverURL;

+ (NSURL *)serverURL;

@end
