//
//  Model.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "Model.h"
#import "NSDate-Utilities.h"

@implementation Model
@synthesize ID;
@synthesize createdBy;
@synthesize createdByEmail;
@synthesize createdDate;

- (id)init {
    self = [super init];
    if (self) {
        self.ID = 0;
        //self.createdByEmail = Shared.email;
		self.createdByEmail = @"";
        self.createdBy = @"";
        self.createdDate = @"";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self)   {
        self.ID = [[dictionary valueForKey:@"id"] intValue]; 
        self.createdByEmail = [dictionary valueForKey:@"created_by_email"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue   {
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:createdByEmail] 
                                       forKeys:[NSArray arrayWithObject:@"created_by_email"]];
}


- (void)dealloc {
    [createdBy release];
    [createdByEmail release];
    [createdDate release];
    [super dealloc];
}

@end
