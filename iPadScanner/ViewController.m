//
//  ViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize serviceManager;

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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView    {
    [super loadView];
    [Bluetooth getInstance].delegate = self;
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    self.serviceManager = [ServiceManager managerWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Bluetooth getInstance].delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated	{
	[super viewWillDisappear:animated];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.serviceManager cancel];
	self.serviceManager.delegate = nil;
	[Bluetooth getInstance].delegate = nil;
}

- (void)dealloc {
    [Bluetooth getInstance].delegate = nil;
	[self.serviceManager cancel];
	self.serviceManager.delegate = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event    {
    [self.view endEditing:YES];
}

- (void)showActivity	{
	activityView.hidden = NO;
}
- (void)hideActivity	{
	activityView.hidden = YES;
}

#pragma mark - ServiceManagerDelegate

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api   {

}

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api   {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Request could not be completed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    [av release];
}

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api	{
	
}

#pragma mark - BluetoothDelegate

- (void)bluetoothDidStartChanging   {
    NSLog(@"Bluetooth CHANGING");
    //[self showActivity];
}

- (void)bluetoothDidTurnOn  {
    NSLog(@"Bluetooth ON");
    //[self hideActivity];
}
- (void)bluetoothDidTurnOff {
    NSLog(@"Bluetooth OFF");
    //[self hideActivity];
}


@end
