//
//  ButtonTableViewCell.m
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

@synthesize button;

- (IBAction)buttonClicked:(UIButton *)sender    {
    
}



- (void)setDictionary:(NSDictionary *)dictionary    {
    [super setDictionary:dictionary];
    [self.button setTitle:[dictionary valueForKey:@"label"] forState:UIControlStateNormal];
}


@end
