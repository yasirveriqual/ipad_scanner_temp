//
//  ReportContentViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 2/14/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "ReportContentViewController.h"

@implementation ReportContentViewController
@synthesize contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated	{
	[super viewWillAppear:animated];
	[self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.01];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Report_Screen_Changed" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
//	(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration   {
//	BOOL isLandscape;
//	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//	if (deviceOrientation == UIDeviceOrientationPortrait ||
//		deviceOrientation == UIDeviceOrientationPortraitUpsideDown ||
//		deviceOrientation == UIDeviceOrientationLandscapeLeft ||
//		deviceOrientation == UIDeviceOrientationLandscapeRight)	{
//		isLandscape = UIDeviceOrientationIsLandscape(deviceOrientation);
//	}	else	{
//		isLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);		
//	}
//	
//	NSString  *imageNamed = [NSString stringWithFormat:@"win-bg-%@.png", isLandscape ? @"L" : @"P"];
//	backgroundImageView.image = [UIImage imageNamed:imageNamed];
//	
//	
//	if (isLandscape)	{
//		self.view.frame = CGRectMake(0, 0, 1024, 570);
//		self.backgroundImageView.frame = CGRectMake(0, 0, 1024, 570);
//		self.navigationController.view.frame = CGRectMake(0, 68, 1024, 570);	
//	}	
//	else	{
//		self.view.frame = CGRectMake(0, 0, 768, 826);
//		self.backgroundImageView.frame = CGRectMake(0, 0, 768, 826);
//		self.navigationController.view.frame = CGRectMake(0, 68, 768, 826);
//	}
//	
//	[self.view setNeedsLayout];
//	NSLog(@"my frame: %@\nback frame: %@\nBg Image: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.backgroundImageView.frame), imageNamed);
}



#pragma mark - IBActions -

- (IBAction)previousClicked	{
	
    [super.navigationController popViewControllerAnimated:YES];
}
@end
