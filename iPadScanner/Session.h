//
//  Session.h
//  iPadScanner
//
//  Created by Yasir Ali on 2/7/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface Session : NSObject
@property (nonatomic, retain) NSString *authenticationToken;
@property (nonatomic, retain) User *user;

+ (NSString *)authenticationToken;
+ (User *)user;


+ (void)loginWithUser:(User *)user withAuthenticationToken:(NSString *)authenticationToken;
+ (void)logout;

+ (Session *)getSession;

@end
