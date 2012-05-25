//
//  SectionView.m
//  iPadScanner
//
//  Created by Yasir Ali on 3/7/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView

@synthesize titleLabel;
@synthesize countLabel;

- (void)dealloc {
    [titleLabel release];
	[countLabel release];
    [super dealloc];
}

@end
