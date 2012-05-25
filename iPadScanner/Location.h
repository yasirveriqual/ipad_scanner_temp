//
//  Location.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/28/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "Model.h"
#import <MapKit/MapKit.h>

@interface Location : Model <NSCoding, MKAnnotation>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (readwrite) int count;


@property (nonatomic, assign) BOOL isSelected;

+ (NSArray *)locationsFromArray:(NSArray *)locations;

@end
