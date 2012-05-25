//
//  ScanTableViewCell.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/24/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "ScanTableViewCell.h"

@implementation ScanTableViewCell

@synthesize showTimer;
@synthesize cView;
@synthesize textLabel;
@synthesize delegate;
@synthesize cellIndex;
@synthesize segmentedControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hideControls	{
	NSLog(@"Called!");
	self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[UIView transitionWithView:self
					  duration:0.25
					   options:UIViewAnimationOptionTransitionFlipFromLeft
					animations:^    {
						[cView removeFromSuperview];
						[self addSubview:textLabel]; 
					}
					completion:NULL];
	[self.showTimer invalidate];
}


- (void)showControls	{
	self.accessoryType = UITableViewCellAccessoryNone;
	[UIView transitionWithView:self
					  duration:0.25
					   options:UIViewAnimationOptionTransitionFlipFromRight
					animations:^    {
						[textLabel removeFromSuperview];
						cView.frame = CGRectMake(0, 0, 240, 40);
						[self addSubview:cView]; 
					}
					completion:NULL];
	self.showTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
}


#pragma mark - IBActions

- (IBAction)segmentedControlValueChanged	{
	[self hideControls];
	if (segmentedControl.selectedSegmentIndex == 0)	{
		[delegate editScanAtIndex:self.cellIndex];
	}	else {
		[delegate scanLocationAtIndex:self.cellIndex];
	}
}

- (void)dealloc {
    [textLabel release];
    [super dealloc];
}

@end
