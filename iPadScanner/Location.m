//
//  Location.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/28/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize name;
@synthesize street;
@synthesize city;
@synthesize state;
@synthesize latitude;
@synthesize longitude;
@synthesize isSelected;
@synthesize count;

@synthesize coordinate;


- (void)dealloc {
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.name = [dictionary valueForKey: @"name"];
        self.latitude = [dictionary valueForKey: @"latitude"];
        self.longitude = [dictionary valueForKey: @"longitude"];
        self.street = [dictionary valueForKey: @"street"];
        self.city = [dictionary valueForKey: @"city"];
        self.state = [dictionary valueForKey: @"state"];
        self.count = [[dictionary valueForKey: @"location_count"] intValue];
		
        self.isSelected = NO;
       
        CLLocationCoordinate2D coor;
        coor.latitude = [self.latitude doubleValue];
        coor.longitude = [self.longitude doubleValue];
        self.coordinate = coor;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"";
        self.street = @"";
        self.city = @"";
        self.state = @"";
        self.latitude = @"";
        self.longitude = @"";
        self.isSelected = NO;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.ID forKey:@"ID"];
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.street forKey:@"street"];
	[aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super init];
	if (self != nil) {
        self.ID = [aDecoder decodeIntForKey:@"ID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.street = [aDecoder decodeObjectForKey:@"street"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
	}
	return self;
	
}


- (NSString *)title {
    if (self.name) {
		if (self.count > 0) {
			return [NSString stringWithFormat:@"Base Location (%d Scan%@)", self.count, (self.count == 1)? @"" : @"s"];
		}
		return @"Base Location";
    }
    else {
        return [NSString stringWithFormat:@"%d Scan%@", self.count, (self.count == 1)? @"" : @"s"];
    }
}

- (NSString *)subtitle {
    if (self.street && self.city && self.state) {
        return [NSString stringWithFormat:@"%@, %@, %@", self.street, self.city, self.state];
    }
    return @"";
}


- (NSDictionary *)dictionaryValue   {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[super dictionaryValue]];
    
    [dictionary setValue:name forKey: @"name"];
    [dictionary setValue:latitude forKey: @"latitude"];
    [dictionary setValue:longitude forKey: @"longitude"];    
    [dictionary setValue:street forKey: @"street"];
    [dictionary setValue:city forKey: @"city"];
    [dictionary setValue:state forKey: @"state"];
    return [dictionary autorelease];
}



+ (NSArray *)locationsFromArray:(NSArray *)locations    {
    NSMutableArray *locationModels = [NSMutableArray array];
    for (NSDictionary *dictionary in locations) {
        Location *location = [[[Location alloc] initWithDictionary:dictionary] autorelease];
        [locationModels addObject:location];
    }
    return locationModels;
}

@end
