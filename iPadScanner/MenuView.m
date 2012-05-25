//
//  MenuView.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/12/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView
@synthesize backgroundImageView;
@synthesize scrollView;
@synthesize containerView;

- (void)awakeFromNib    {
    [super awakeFromNib];
    self.scrollView.contentSize = containerView.frame.size;
}


- (void)changeOrientationToLandscape:(BOOL)yesOrNo  {
    backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mainPanel-%@-bg.png", yesOrNo ? @"L" : @"P"]];
}

- (IBAction)newScanClicked  {
    NSLog(@"Email Clicked");
}

- (IBAction)registerClicked {
    NSLog(@"Email Clicked");
}

- (IBAction)locationClicked {
    NSLog(@"Email Clicked");
}

- (IBAction)reportsClicked  {
    NSLog(@"Email Clicked");
}

- (IBAction)emailClicked    {
    NSLog(@"Email Clicked");
}



@end
