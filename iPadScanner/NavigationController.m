//
//  NavigationController.m
//  iPadScanner
//
//  Created by Adeel on 1/23/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController
@synthesize mainViewController;

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

#pragma mark - MainViewControllerDelegate

- (void)didLogout {
	[mainViewController.settingsPopoverController dismissPopoverAnimated:YES];
	mainViewController.editing = NO;
	mainViewController.delegate = nil;
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor blackColor];
    
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    mainVC.delegate = self;
	self.mainViewController = mainVC;
    [self setViewControllers:[NSArray arrayWithObject:mainVC]];
    [mainVC release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
