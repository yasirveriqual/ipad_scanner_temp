//
//  Connection.m
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "Connection.h"

@implementation Connection

@synthesize host;
@synthesize port;
@synthesize username;
@synthesize password;

- (id)init {
    self = [super init];
    if (self) {
        self.host = @"10.10.10.48";
        self.port = @"389";
        self.username = @"cn=admin,dc=ics,dc=com";
        self.password = @"ldapadmin";
    }
    return self;
}

- (NSDictionary *)dictionaryValue   {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:host forKey:@"host"];
    [dictionary setValue:port forKey:@"port"];
    [dictionary setValue:username forKey:@"user_name"];
    [dictionary setValue:password forKey:@"password"];
    return dictionary;
}

- (void)dealloc
{
    [host release];
	[port release];
	[username release];
	[password release];
    [super dealloc];
}

@end
/*
host: 50.17.232.163
 port: 389
[11/29/11 11:40:27 AM] Muhammad Rizwan:   user_name: cn=admin,dc=ics,dc=com
 password: ICSsurvey123
*/