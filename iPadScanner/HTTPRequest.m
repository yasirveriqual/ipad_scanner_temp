//
//  HTTPRequest.m
//  iPadScanner
//
//  Created by Adeel Rehman on 11/14/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest

@synthesize apiName;
@synthesize object;

- (id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    if (self) {
        self.apiName = @"";
    }
    return self;
}


- (void)dealloc {
    [apiName release];
	[object release];
    [super dealloc];
}

@end
