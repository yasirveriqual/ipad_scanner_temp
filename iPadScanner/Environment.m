//
//  Environment.m
//  iPadScanner
//
//  Created by Yasir Ali on 4/19/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "Environment.h"

static Environment *sharedInstance = nil;

@implementation Environment
@synthesize serverURL;

- (void)initializeSharedInstance
{
	NSString* configuration = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];
	NSBundle* bundle = [NSBundle mainBundle];
	NSString* envsPListPath = [bundle pathForResource:@
							   "Environment" ofType:@"plist"];
	NSDictionary* environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
	NSDictionary* environment = [environments objectForKey:configuration];
	
	NSString *serverIP = [environment valueForKey:@"ServerIP"];
	
	self.serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:3002/api/", serverIP]];
	
	[environments release];
}
#pragma mark - Lifecycle Methods

+ (Environment *)sharedInstance
{
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[self alloc] init];
			[sharedInstance initializeSharedInstance];
		}
		return sharedInstance;
	}
}

- (NSUInteger) retainCount
{
	return NSUIntegerMax;
}

- (oneway void) release
{
	// Do Nada
}

- (id) autorelease
{
	return self;
}

- (id) retain
{
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

+ (NSURL *)serverURL	{
	return [[Environment sharedInstance] serverURL];
}



@end
