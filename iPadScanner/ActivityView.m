//
//  ActivityView.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/31/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ActivityView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ActivityView

- (void)awakeFromNib	{
	[super awakeFromNib];
	
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark Methods

- (void)setHidden:(BOOL)h	{
	super.hidden = h;
	if (h)
		[activityIndicatorView stopAnimating];
	else
		[activityIndicatorView startAnimating];
}

- (BOOL)hidden	{
	return super.hidden;
}

@end
