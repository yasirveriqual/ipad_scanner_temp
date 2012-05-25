//
//  LocationManager.m
//  iPadScanner
//
//  Created by Adeel Rehman on 10/23/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "LocationManager.h"

static LocationManager *manager = nil;

@implementation LocationManager

@synthesize locationManager;
@synthesize userLocation;
@synthesize bestEffortAtLocation;
@synthesize delegate;

+ (LocationManager *)getInstance	{
	@synchronized(self)	{
		if (manager == nil)	{
			manager = [[LocationManager alloc] init];
		}
	}
	return manager;
}

- (id) init	{
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        CLLocation *tempLoc	=[[CLLocation alloc] initWithLatitude:31.532 longitude:74.352];
		self.userLocation = tempLoc;
		[tempLoc release];
        
		[locationManager startUpdatingLocation];
	}
	return self;
}

- (void) dealloc	{
	[locationManager release];
	[userLocation release];
	[bestEffortAtLocation release];
	[super dealloc];
}


#pragma mark -- LocationManger delegate Methods --
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	self.userLocation=newLocation;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSMutableString *errorString = [[[NSMutableString alloc] init] autorelease];
	if ([error domain] == kCLErrorDomain) {
		switch ([error code]) {
			case kCLErrorDenied:
				[errorString appendString:@"Location Denied"];
				break;
			case kCLErrorLocationUnknown:
				[errorString appendString:@"Location Unknown"];
				break;
			default:
				[errorString appendString:@"General Error"];
				break;
		}
	} else {
		[errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
        
	}
}

#pragma mark -- Utility location base methods --

-(double)distanceFromLocation:(CLLocation*)newLocation	{
	CLLocationDistance distanceMoved = [self.userLocation distanceFromLocation:newLocation];
	NSString *temp = [NSString stringWithFormat:@"%f", distanceMoved];
	return [temp doubleValue];
}


@end
