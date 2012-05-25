//
//  ServiceManager.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceManagerDelegate.h"
#import "HTTPRequest.h"

@class Model;

@interface ServiceManager : NSObject <UIAlertViewDelegate>   {
    NSURLConnection *connection;
    NSMutableData *data;
    NSUInteger statusCode;
}

@property (nonatomic, retain) HTTPRequest *request;
@property (nonatomic, assign) id <ServiceManagerDelegate> delegate;


+ (ServiceManager *)managerWithDelegate:(id)delegate;

- (void)requestApi:(NSString *)apiName usingObject:(Model *)object;
- (void)requestApi:(NSString *)apiName usingObject:(Model *)object requestMethod:(NSString *)requestMethod;

- (void)requestApi:(NSString *)apiName forClass:(NSString *)className usingObj:(id)object;
- (void)requestApi:(NSString *)apiName forClass:(NSString *)className usingObj:(id)object requestMethod:(NSString *)requestMethod;

- (void)cancel;
@end
