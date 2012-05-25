//
//  LabelTableViewCell.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/7/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "LabelTableViewCell.h"

@implementation LabelTableViewCell
@synthesize textLabel, valueLabel;

- (void)setDictionary:(NSDictionary *)dictionary    {
    [super setDictionary:dictionary];
    self.textLabel.text = [dictionary valueForKey:@"label"];
    self.valueLabel.text = [dictionary valueForKey:@"value"];
}


@end
