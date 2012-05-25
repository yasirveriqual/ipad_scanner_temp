//
//  ReportPreviewViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 2/14/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "ReportPreviewViewController.h"
#import "Scan.h"
#import "EmployeeTableViewCell.h"
#import "Shared.h"
#import "SectionView.h"
#import <QuartzCore/QuartzCore.h>
#import "Session.h"

@implementation ReportPreviewViewController
@synthesize statusAlertView;
@synthesize tableView;
@synthesize scanSessionIds;
@synthesize scanSessions;
@synthesize recordCountLabel;
@synthesize submitButton;
@synthesize previousButton;
@synthesize tableContentView;

- (id)initWithScanSessionIds:(NSArray *)ids
{
    self = [super initWithNibName:@"ReportPreviewViewController" bundle:nil];
    if (self) {
        self.scanSessionIds = [NSArray arrayWithArray:ids];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.submitButton.enabled = NO;
	
	self.tableContentView.layer.borderColor = [UIColor grayColor].CGColor;
	self.tableContentView.layer.borderWidth = 1;
	
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.scanSessionIds forKey:@"scan_session_ids"];
    [self.serviceManager requestApi:@"scan_sessions/get_scans_by_scan_session_ids" forClass:@"scan" usingObj:dictionary];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[scanSessionIds release];
	scanSessionIds = nil;
	
	[scanSessions release];
	scanSessions = nil;
	
	[tableView release];
	tableView = nil;

	[recordCountLabel release];
	recordCountLabel = nil;
	
	
	statusAlertView.delegate = nil;
	[statusAlertView release];
	statusAlertView = nil;
}

- (void)dealloc
{
	[scanSessionIds release];
	scanSessionIds = nil;
	
	[scanSessions release];
	scanSessions = nil;
	
	[tableView release];
	tableView = nil;
	
	[recordCountLabel release];
	recordCountLabel = nil;
	
	statusAlertView.delegate = nil;
	[statusAlertView release];
	statusAlertView = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	  //:@"Submitted_Report" object:nil];
    [super dealloc];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration	{
	[self.tableView reloadData];
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark - IBActions -

- (IBAction)submitClicked	{
	self.submitButton.enabled = NO;
	self.previousButton.enabled = NO;
	    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	    [dictionary setObject:scanSessionIds forKey:@"scan_ids"];
	    [dictionary setObject:Session.user.email forKey:@"requested_by_email"];
#if TARGET_IPHONE_SIMULATOR
	    [dictionary setObject:@"123-23421" forKey:@"device_token"];
#else
		[dictionary setObject:[Shared instance].deviceToken forKey:@"device_token"];
#endif
	    [self.serviceManager requestApi:@"reports/generate_report_and_send_email" forClass:@"batch" usingObj:dictionary requestMethod:@"POST"];
}

#pragma mark - DELEGATES -
#pragma mark UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView	{
	if (scanSessions == nil) return 0;
    return scanSessions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
	if ([[[scanSessions objectAtIndex:section] employees] count] == 0) return 1;
    return [[[scanSessions objectAtIndex:section] employees] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	Scan *scan = [scanSessions objectAtIndex:indexPath.section];
	UITableViewCell *cell;
	if (scan.employees.count)	{
		static NSString *CellIdentifier = @"EmployeeTableViewCellIdentifier";
		
		EmployeeTableViewCell *ecell;
		ecell = (EmployeeTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (ecell == nil)	{
			ecell = [[[NSBundle mainBundle] loadNibNamed:@"EmployeeTableViewCell" owner:self options:nil] objectAtIndex:0];
		}
		
		ecell.employee = [scan.employees objectAtIndex:indexPath.row];
		cell = ecell;
	}	else	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoCheckinsCellIdentifier"] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.textLabel.text = @"No Result(s) found.";
	}
    return cell;        
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section	{
	if (scanSessions == nil) return 0;
	return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section	{
	UIView *v = nil;
	if (scanSessions == nil) return nil;
	Scan *scan = [scanSessions objectAtIndex:section];
	
	SectionView *sectionView;
	sectionView = (SectionView *)[[[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:self options:nil] objectAtIndex:0];
	sectionView.titleLabel.text = [scan scanSessionName];
	sectionView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 35);
	NSLog(@"%@", NSStringFromCGRect(sectionView.frame));
	int employees = scan.employees.count;
	sectionView.countLabel.text = [NSString stringWithFormat:@"%i Record%@", employees, (employees <= 1) ? @"" : @"s"];
	v = sectionView;
	return v;
}


#pragma mark ServiceManagerDelegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api   {
    if ([api isEqualToString:@"scan_sessions/get_scans_by_scan_session_ids"])    {
		self.submitButton.enabled = YES;
		
		self.scanSessions = [Scan scansFromArray:[response valueForKey:@"scan_sessions"]];
		[self.tableView reloadData];
		int count = 0;
		for (Scan *scan in self.scanSessions) {
			count += scan.employees.count;
		}
		self.recordCountLabel.text = [NSString stringWithFormat:@"%i Record%@", count, (count <= 1) ? @"" : @"s"];
    }   
    else {
        self.statusAlertView = [[[UIAlertView alloc] initWithTitle:@"Information!" message:@"Report data submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [statusAlertView show];
    }
}


- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api {
    if ([api isEqualToString:@"scan_sessions/get_by_location_ids_and_email"] || [api isEqualToString:@"scan_sessions/get_by_emails"] || [api isEqualToString:@"reports/generate_report_and_send_email"]) {
        
        UIAlertView *av;
        if (code == 404 || code == 500 || code == 501) {
			av = [[UIAlertView alloc] initWithTitle:[response valueForKey:@"status"] message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
        else if (code == 999) {
            av = [[UIAlertView alloc] initWithTitle:@"Unknown Error" message:@"Invalid response from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
    }
	self.submitButton.enabled = YES;
	self.previousButton.enabled = YES;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == alertView.cancelButtonIndex) { // PRESS OK
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Submitted_Report" object:nil];
		
		self.submitButton.enabled = YES;
		self.previousButton.enabled = YES;
		[Shared instance].reportEmergencyId = nil;
    }
}

@end
