//
//  Session.m
//  iPadScanner
//
//  Created by Yasir Ali on 2/7/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "Session.h"
#import "User.h"
#import "iPadScannerAppDelegate.h"

static Session *object;

@implementation Session
@synthesize user;
@synthesize authenticationToken;

+ (Session *)getSession {
    @synchronized(self) {
        if (object == nil)  {
            object = [[Session alloc] init];
        }
    }
    return object;
}

+ (void)initialize	{
	static BOOL initialized = NO;
    if(!initialized)	{
        initialized = YES;
        object = [[Session alloc] init];
	}
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
	
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}


+ (NSString *)authenticationToken	{
	return [self getSession].authenticationToken;
}

+ (User *)user	{
	return [self getSession].user;
}

+ (void)loginWithUser:(User *)user withAuthenticationToken:(NSString *)authenticationToken	{
	[self getSession].user = user;
	[self getSession].authenticationToken = authenticationToken;
}

+ (void)logout	{
	[self getSession].user = nil;
	[self getSession].authenticationToken = nil;
}

- (void)dealloc
{
    [authenticationToken release];
	[user release];
    [super dealloc];
}

@end
