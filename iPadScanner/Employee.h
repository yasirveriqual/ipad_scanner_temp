//
//  Employee.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "Model.h"

@interface Employee : Model

@property (retain, nonatomic) NSString* cubicalNumber;
@property (retain, nonatomic) NSString* emailAddress;
@property (retain, nonatomic) NSString* firstName;
@property (retain, nonatomic) NSString* floorNumber;
@property (retain, nonatomic) NSString* lastName;
@property (retain, nonatomic) NSString* middleName;
@property (retain, nonatomic) NSString* phoneNumber;
@property (retain, nonatomic) NSString* rfid;

@property (assign, nonatomic) NSUInteger locationID;
@property (retain, nonatomic) NSString* locationName;
@property (retain, nonatomic) NSString* latitude;
@property (retain, nonatomic) NSString* longitude;

@property (readwrite) BOOL isManual;


@end
