//
//  Shared.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/28/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "Shared.h"
#import "LocationManager.h"

static Shared *object;

@implementation Shared

@synthesize isHostReachable;
@synthesize isWiFiAvailable;

@synthesize baseLocation;
@synthesize selectedLocationIndex;
@synthesize distance;

@synthesize reportEmergencyId;

@synthesize deviceToken;


+ (Shared *)instance {
    @synchronized (self) {
		if (object == nil) {
			object = [[Shared alloc] init];
		}
	}
//	NSLog(@"To Date: %@, From Date: %@", object.toDate, object.fromDate);
	return object;
}

+ (void)release	{
//	[[self instance] release];
}

- (id)init {
    self = [super init];
    if (self) {
		
    }
    return self;
}


- (void) dealloc    {
	[reportEmergencyId release];
	[baseLocation release];
	[deviceToken release];
    [super dealloc];
}


- (NSUInteger)selectedLocationIndex {
    NSUInteger selectedIndex = NSUIntegerMax;
    NSString *selectedLocationIndexString = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedLocationIndex"];
    if (selectedLocationIndexString != nil) return [selectedLocationIndexString integerValue];
    return selectedIndex;
}

- (void)setSelectedLocationIndex:(NSUInteger)index  {
    selectedLocationIndex = index;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", index] forKey:@"selectedLocationIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (float)distance   {
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"distance"];
}

- (void)setDistance:(float)dis  {
    distance = dis;
    [[NSUserDefaults standardUserDefaults] setFloat:distance forKey:@"distance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL)isNetworkAvailable {
    if (object.isHostReachable || object.isWiFiAvailable) {
        return YES;
    }
    else {
        return NO;
    }
}


- (void)loadBaseLocation {
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSMutableString *savePath = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
	[savePath appendString:@"/base_location_info.plist"];
	
	NSData* data = [NSData dataWithContentsOfFile:savePath];
	Location *rootObject = (Location*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	if (rootObject == nil) {
		self.baseLocation = [[[Location alloc] init] autorelease];
	}
	else {
		self.baseLocation = rootObject;
	}
}


- (void)saveBaseLocation {
    if(self.baseLocation!=nil){
		
		NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSMutableString *savePath  = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
		[savePath appendString:@"/base_location_info.plist"];
		
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.baseLocation];
		[data writeToFile:savePath atomically:YES];	
	}
}

+ (NSString *)email {
    return Session.user.email;
}

+ (float)distance {
    return [Shared instance].distance;
}

+ (Location *)baseLocation  {
    return [Shared instance].baseLocation;
}


- (NSDate *)toDate  {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"toDate"];
}

- (void)setToDate:(NSDate *)tDate    {
    [[NSUserDefaults standardUserDefaults] setValue:tDate forKey:@"toDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSDate *)fromDate  {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"fromDate"];
}

- (void)setFromDate:(NSDate *)frmDate    {
    [[NSUserDefaults standardUserDefaults] setValue:frmDate forKey:@"fromDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

