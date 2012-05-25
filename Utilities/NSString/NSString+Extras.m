//
//  NSString+Extras.m
//  iPadScanner
//
//  Created by Adeel Rehman on 11/15/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "NSString+Extras.h"

@implementation NSString (Extras)

- (NSString *)htmlEntityDecode
{
    self = [self stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    self = [self stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    self = [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    self = [self stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    self = [self stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    return self;
}

@end
