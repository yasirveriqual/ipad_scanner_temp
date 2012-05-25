//
//  UserLocation.m
//  iPadScanner
//
//  Created by Adeel Rehman on 10/23/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "UserLocation.h"

@implementation UserLocation

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}


@end
