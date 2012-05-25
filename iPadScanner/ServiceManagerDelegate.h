//
//  ServiceManagerDelegate.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServiceManagerDelegate <NSObject>
- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api;
- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api;

@optional
- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api;
@end
