//
//  LocationManager.h
//  iPadScanner
//
//  Created by Adeel Rehman on 10/23/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>
- (void)didReceiveLocation:(CLLocation *)location;
- (void)didFailedToReceiveLocation:(NSError *)error;
@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>	{
	CLLocationManager *locationManager;
	CLLocation *userLocation;
	CLLocation *bestEffortAtLocation;
    id <LocationManagerDelegate> delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;
@property (nonatomic, assign) id<LocationManagerDelegate> delegate;

-(double)distanceFromLocation:(CLLocation*)newLocation;
+ (LocationManager *)getInstance;

@end

