//
//  Emergency.m
//  iPadScanner
//
//  Created by Adeel Rehman on 12/9/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "Emergency.h"
#import "NSDate-Utilities.h"

@implementation Emergency

@synthesize name, startDate;


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.name = [dictionary valueForKey: @"name"];
        self.startDate = [NSDate dateFromInternetDateTimeString:[dictionary valueForKey: @"start_date"]];
    }
    return self;
}


- (NSDictionary *)dictionaryValue   {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[super dictionaryValue]];
    
    [dictionary setValue:name forKey: @"name"];
    [dictionary setValue:[startDate rfc3339String] forKey: @"start_date"];
    
    return [dictionary autorelease];
}


- (id)init {
    self = [super init];
    if (self) {
        self.name = @"";
    }
    return self;
}

- (void)dealloc
{
    [name release];
	[startDate release];
    [super dealloc];
}

@end
