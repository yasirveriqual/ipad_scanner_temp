//
//  ReportGenerationViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/20/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ReportGenerationViewController.h"
#import "ReportBasicInformationViewController.h"

@implementation ReportGenerationViewController
@synthesize reportNavigationController;
@synthesize backgroundImageView;
@synthesize navigationImageView;

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

- (void)loadView    {
    [super loadView];
    
    self.title = @"Report Generation";
    
    ReportBasicInformationViewController *viewController = [[ReportBasicInformationViewController alloc] initWithNibName:@"ReportBasicInformationViewController" bundle:nil];

    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navigationController.navigationBarHidden = YES;
	[navigationController shouldAutorotateToInterfaceOrientation:YES];
	
    [self.view addSubview:navigationController.view];
	navigationController.view.frame = CGRectMake(0, 68, 1024, 570);
	navigationController.view.clipsToBounds = YES;
    self.reportNavigationController = navigationController;
	[viewController release];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportScreenChanged) name:@"Report_Screen_Changed" object:nil];
}

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
//    [self adjustOrientation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportDataSubmitted) name:@"Submitted_Report" object:nil];
     
     //postNotificationName:@"Submitted_Report" object:nil];
}

- (void)viewDidAppear:(BOOL)animated	{
	[super viewDidAppear:animated];
//	[self didRotateFromInterfaceOrientation:self.interfaceOrientation];
}

- (void)viewWillDisappear:(BOOL)animated    {
    [super viewWillDisappear:animated];	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"Report_Screen_Changed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Submitted_Report" object:nil];
}

- (void)reportScreenChanged	{
	self.navigationImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"step-%i-%i.png", Session.user.group, self.reportNavigationController.viewControllers.count]];
}

- (void)reportDataSubmitted {
    [super.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)adjustOrientation	{
//	BOOL isLandscape;
//	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//	if (deviceOrientation == UIDeviceOrientationFaceUp || deviceOrientation == UIDeviceOrientationFaceDown)	{
//		NSLog(@"Now returning...!");
//		return;
//	}
//	else if (deviceOrientation == UIDeviceOrientationPortrait ||
//		deviceOrientation == UIDeviceOrientationPortraitUpsideDown ||
//		deviceOrientation == UIDeviceOrientationLandscapeLeft ||
//		deviceOrientation == UIDeviceOrientationLandscapeRight)	{
//		isLandscape = UIDeviceOrientationIsLandscape(deviceOrientation);
//	}	else	{
//		isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);		
//	}
//    
//    NSString  *imageNamed = [NSString stringWithFormat:@"background-%@.png", isLandscape ? @"L" : @"P"];
//    backgroundImageView.image = [UIImage imageNamed:imageNamed];
//	[self.reportNavigationController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.01];
//	NSLog(@"REP Navigation Controller frame: %@\nBg image: %@", NSStringFromCGRect(self.reportNavigationController.view.frame), imageNamed);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration   {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//	[self adjustOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation	{
//	[self adjustOrientation];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


@end
