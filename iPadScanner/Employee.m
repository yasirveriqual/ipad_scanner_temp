//
//  Employee.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "Employee.h"

@implementation Employee

@synthesize ID;
@synthesize cubicalNumber;
@synthesize emailAddress;
@synthesize firstName;
@synthesize floorNumber;
@synthesize lastName;
@synthesize middleName;
@synthesize phoneNumber;
@synthesize rfid;
@synthesize locationID;
@synthesize locationName;
@synthesize latitude;
@synthesize longitude;
@synthesize isManual;


- (void)dealloc {
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    NSLog(@"Dictionary: %@", dictionary);
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.cubicalNumber = [dictionary valueForKey: @"cubical_number"];
        self.emailAddress = [dictionary valueForKey: @"email_address"];
        self.firstName = [dictionary valueForKey: @"first_name"];
        self.floorNumber = [dictionary valueForKey: @"floor_number"];
        self.lastName = [dictionary valueForKey: @"last_name"];
        self.middleName = [dictionary valueForKey: @"middle_name"];
        self.phoneNumber = [dictionary valueForKey: @"phone_number"];
        self.rfid = [dictionary valueForKey: @"rf_id"];
        self.locationID = [[dictionary valueForKey:@"location_id"] integerValue];
        self.locationName = [dictionary valueForKey: @"location_name"];
        self.latitude = [dictionary valueForKey: @"latitude"];
        self.longitude = [dictionary valueForKey: @"longitude"];
		self.isManual = [[dictionary valueForKey:@"is_manual"] boolValue];
    }
    return self;
}

- (NSDictionary *)dictionaryValue   {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[super dictionaryValue]];

    [dictionary setValue:rfid forKey: @"rf_id"];
    [dictionary setValue:firstName forKey: @"first_name"];
    [dictionary setValue:middleName forKey: @"middle_name"];
    [dictionary setValue:lastName forKey: @"last_name"];
    [dictionary setValue:cubicalNumber forKey: @"cubical_number"];
    [dictionary setValue:emailAddress forKey: @"email_address"];
    [dictionary setValue:floorNumber forKey: @"floor_number"];
    [dictionary setValue:phoneNumber forKey: @"phone_number"];
    [dictionary setValue:locationName forKey: @"location_name"];
    [dictionary setValue:latitude forKey: @"latitude"];
    [dictionary setValue:longitude forKey: @"longitude"];

    return [dictionary autorelease];
}


@end
