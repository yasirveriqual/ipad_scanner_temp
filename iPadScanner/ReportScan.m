//
//  ReportScan.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/26/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ReportScan.h"

@implementation ReportScan

@synthesize isSelected;
@synthesize name;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.name = [dictionary valueForKey:@"name"];
        self.isSelected = NO;
    }
    return self;
}

- (void)dealloc
{
    [name release];
    [super dealloc];
}

@end
