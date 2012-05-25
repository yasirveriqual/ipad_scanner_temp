//
//  TableViewCell.m
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
@synthesize delegate;
@synthesize dictionary;
@synthesize textLabel;


- (void)setDictionary:(NSMutableDictionary *)dic    {
    if (dictionary) {
        [dictionary release];
    }
    dictionary = [dic retain];
    self.textLabel.text = [dictionary valueForKey:@"label"];
}

- (void)dealloc {
    [textLabel release];
    [dictionary release];
    [super dealloc];
}

@end
