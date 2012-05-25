//
//  Model.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, readwrite) int ID;
@property (retain, nonatomic) NSString* createdBy;
@property (retain, nonatomic) NSString* createdByEmail;
@property (retain, nonatomic) NSString* createdDate;


- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryValue;
/*
+ (NSString *)localsoapEnvelopeForMethod:(NSString *)method usingDictionary:(NSDictionary *)dictionary;
+ (NSString *)soapEnvelopeForMethod:(NSString *)method usingDictionary:(NSDictionary *)dictionary;

+ (NSString *)soapEnvelopeForMethod:(NSString *)method usingInput:(NSString *)input usingDictionary:(NSDictionary *)dictionary;
+ (id)objectFromSoapEnvelope:(NSString *)envelope withFault:(Fault **)fault;
*/
@end
