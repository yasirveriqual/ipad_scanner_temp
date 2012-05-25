//
//  User.m
//  iPadScanner
//
//  Created by Adeel Rehman on 11/30/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize email;
@synthesize password;
@synthesize group;
@synthesize isSelected;


- (id)initWithEmail:(NSString *)emailAddress   {
    self = [super init];
    if (self)   {
        self.email = emailAddress;
        self.isSelected = NO;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.email = [dictionary valueForKey:@"email"];
        self.password = [dictionary valueForKey:@"password"];
        self.group = UserGroupUndefined;
    }
    return self;
}



- (NSDictionary *)dictionaryValue   {
    return [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil];
}

- (void)setUserGroupWithName:(NSString *)groupName  {
    if ([groupName isEqualToString:@"admins"])    {
        self.group = UserGroupAdministrator;
    }
    else if ([groupName isEqualToString:@"firemarshals"])    {
        self.group = UserGroupFiremarshal;
    }
}

- (void)dealloc
{
    [email release];
	[password release];
    [super dealloc];
}

@end
