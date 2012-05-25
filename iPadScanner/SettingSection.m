//
//  SettingSections.m
//  iPadScanner
//
//  Created by Yasir Ali on 11/28/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "SettingSection.h"

@implementation SettingSection

@synthesize ID;
@synthesize name;
@synthesize items;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.ID = [dictionary valueForKey:@"id"];
        self.name = [dictionary valueForKey:@"name"];
    }
	
    return self;
}

@end
