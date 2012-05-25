//
//  Scan.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/21/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "Scan.h"
#import "Employee.h"

@implementation Scan

@synthesize employees;
@synthesize emergency;
@synthesize scanSessionName, scanSessionStartDate, scanSessionEndDate, emergencyId;

- (id)init {
    self = [super init];
    if (self) {
        self.scanSessionName = @"";
        self.scanSessionStartDate = @"";
        self.scanSessionEndDate = @"";
        self.emergencyId = @"";
        
        self.employees = [NSMutableArray array];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.scanSessionName = [dictionary valueForKey:@"name"];
		
		if ([dictionary valueForKey:@"start_date"] != nil)
			self.scanSessionStartDate = [dictionary valueForKey:@"start_date"];
		
		if ([dictionary valueForKey:@"end_date"] != nil)
			self.scanSessionEndDate = [dictionary valueForKey:@"end_date"];
		
		if ([dictionary valueForKey:@"emergency_id"] != nil)
			self.emergencyId = [dictionary valueForKey:@"emergency_id"];
		
		NSMutableArray *employeesArray = [NSMutableArray array];
		if ([dictionary valueForKey:@"scans"] != nil)	{
			for (NSDictionary *d in [dictionary valueForKey:@"scans"]) {
				Employee *employee = [[[Employee alloc] initWithDictionary:d] autorelease];
				[employeesArray addObject:employee];
			}
		}
        
        self.employees = employeesArray;
    }
    return self;
}

- (NSDictionary *)dictionaryValue   {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[super dictionaryValue]];
    
    [dictionary setValue:self.scanSessionName forKey: @"name"];
    [dictionary setValue:self.scanSessionStartDate forKey: @"start_date"];
    [dictionary setValue:self.scanSessionEndDate forKey: @"end_date"];
    //[dictionary setValue:[NSString stringWithFormat:@"%d", self.emergency.ID] forKey: @"emergency_id"];
    
    return [dictionary autorelease];
}



+ (NSArray *)scansFromArray:(NSArray *)scansArray	{
	NSMutableArray *scans = [NSMutableArray array];
	for (NSDictionary *dicationary in scansArray) {
		Scan *scan = [[[Scan alloc] initWithDictionary:dicationary] autorelease];
		[scans addObject:scan];
	}
	return scans;
}

@end
