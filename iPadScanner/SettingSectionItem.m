//
//  SettingSectionItem.m
//  iPadScanner
//
//  Created by Yasir Ali on 11/28/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "SettingSectionItem.h"

@implementation SettingSectionItem

@synthesize ID;
@synthesize name;
@synthesize type;
@synthesize value;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.ID = [dictionary valueForKey:@"id"];
        self.name = [dictionary valueForKey:@"name"];
        self.type = [dictionary valueForKey:@"type"];
        self.value = [dictionary valueForKey:@"value"];
    }
    return self;
}

@end
