//
//  ReportScanSessionsViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/23/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ReportScanSessionsViewController.h"
#import "ReportPreviewViewController.h"
#import "ReportScan.h"

@implementation ReportScanSessionsViewController
@synthesize tableView;
@synthesize previewButton;
@synthesize emails;
@synthesize locations;
@synthesize selectedScans;

@synthesize scans;

- (id)initWithLocations:(NSArray *)scanLocations    {
    self = [super initWithNibName:@"ReportScanSessionsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.locations = scanLocations;
    }
    return self;
}

- (id)initWithEmails:(NSArray *)officerEmails  {
    self = [super initWithNibName:@"ReportScanSessionsViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.emails = officerEmails;
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	NSLog(@"Button Frame: %@", NSStringFromCGRect(previewButton.frame));
	NSLog(@"Button Enabled: %i", previewButton.enabled);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedScans = [NSMutableArray array];
    if (Session.user.group == UserGroupAdministrator) {
//        [self.serviceManager requestApi:@"scan_sessions/get_by_emails" forClass:@"scan" usingObj:[NSDictionary dictionaryWithObject:emails forKey:@"emails"]];
		[self.serviceManager requestApi:@"scan_sessions/get_by_emails_and_emergency" forClass:@"scan" usingObj:[NSDictionary dictionaryWithObjectsAndKeys:emails, @"emails", [Shared instance].reportEmergencyId, @"emergency_id", nil]];
    }   
    else if (Session.user.group == UserGroupFiremarshal)  {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:Session.user.email forKey:@"email"];
        [dictionary setValue:locations forKey:@"ids"];
		[dictionary setValue:[Shared instance].reportEmergencyId forKey:@"emergency_id"];
		[self.serviceManager requestApi:@"scan_sessions/get_by_location_ids_and_email_and_emergency" forClass:@"location" usingObj:dictionary];
//        [self.serviceManager requestApi:@"scan_sessions/get_by_location_ids_and_email" forClass:@"location" usingObj:dictionary];
    }
    
    self.previewButton.enabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - IBAction

- (IBAction)previewClicked   {
	ReportPreviewViewController *viewController = [[ReportPreviewViewController alloc] initWithScanSessionIds:selectedScans];
	[super.navigationController pushViewController:viewController animated:YES];
	[viewController release];
	 //    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    [dictionary setObject:selectedScans forKey:@"scan_ids"];
//    [dictionary setObject:Session.user.email forKey:@"requested_by_email"];
//    [dictionary setObject:[Shared instance].deviceToken forKey:@"device_token"];
//    [self.serviceManager requestApi:@"reports/generate_report_and_send_email" forClass:@"batch" usingObj:dictionary requestMethod:@"POST"];
}

#pragma mark - DELEGATES -
#pragma mark ServiceManagerDelegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api   {
    if ([api isEqualToString:@"scan_sessions/get_by_location_ids_and_email_and_emergency"] || [api isEqualToString:@"scan_sessions/get_by_emails_and_emergency"])    {
        NSArray *scan_sessions = [response objectForKey:@"scan_sessions"];
        NSMutableArray *scan_models = [NSMutableArray arrayWithCapacity:scan_sessions.count];
        for (NSDictionary *dictionary in scan_sessions) {
            [scan_models addObject:[[[ReportScan alloc] initWithDictionary:dictionary] autorelease]];
        }
        self.scans = scan_models;
        [self.tableView reloadData];
    }   
    
    else    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Report data submitted successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
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
}


#pragma mark - UITableViewDelegate & DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return self.scans.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"CheckboxTableViewCellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
	}
    
    ReportScan *scan = [scans objectAtIndex:indexPath.row];
    cell.textLabel.text = scan.name;
    cell.accessoryType = scan.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath	{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	BOOL isSelected = (cell.accessoryType == UITableViewCellAccessoryNone);
	cell.accessoryType =  isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	ReportScan *scan = [scans objectAtIndex:indexPath.row];
    scan.isSelected = isSelected;
    
    if (isSelected)    {
        [self.selectedScans addObject:[NSString stringWithFormat:@"%i", scan.ID]];
    }   else   {
        [self.selectedScans removeObject:[NSString stringWithFormat:@"%i", scan.ID]];
    }
    self.previewButton.enabled = self.selectedScans.count;
}




@end
