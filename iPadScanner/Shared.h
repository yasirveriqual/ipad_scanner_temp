//
//  Shared.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/28/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "User.h"


@interface Shared : NSObject

@property (readwrite) BOOL isHostReachable;
@property (readwrite) BOOL isWiFiAvailable;

@property (nonatomic, assign) float distance;
@property (nonatomic, retain) Location *baseLocation;
@property (nonatomic, assign) NSUInteger selectedLocationIndex;

@property (nonatomic, assign) NSDate *toDate;
@property (nonatomic, assign) NSDate *fromDate;

@property (nonatomic, retain) NSString *deviceToken;

@property (nonatomic, retain) NSString *reportEmergencyId;


+ (Shared *)instance;
+ (BOOL)isNetworkAvailable;

- (void)loadBaseLocation;
- (void)saveBaseLocation;

+ (NSString *)email;
+ (Location *)baseLocation;
+ (float)distance;

@end
