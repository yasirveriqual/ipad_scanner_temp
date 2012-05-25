//
//  ReportOfficersViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/23/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ReportOfficersViewController.h"
#import "User.h"
#import "ReportScanSessionsViewController.h"


@implementation ReportOfficersViewController

@synthesize tableView;
@synthesize officers;
@synthesize locations;
@synthesize selectedOfficers;

@synthesize nextButton;

- (id)initWithLocations:(NSArray *)locationsArray
{
    self = [super initWithNibName:@"ReportOfficersViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.locations = locationsArray;
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
	
	NSLog(@"Button Frame: %@", NSStringFromCGRect(nextButton.frame));
	NSLog(@"Button Enabled: %i", nextButton.enabled);
}



#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView flashScrollIndicators];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.officers = [NSArray array];
    [self.serviceManager requestApi:@"employees/get_emails_by_location_ids" forClass:@"location" usingObj:[NSDictionary dictionaryWithObject:locations forKey:@"ids"]];
    self.selectedOfficers = [NSMutableArray array];
    self.nextButton.enabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - IBAction

- (IBAction)nextClicked {
    ReportScanSessionsViewController *viewController = [[ReportScanSessionsViewController alloc] initWithEmails:selectedOfficers];
    [super.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


#pragma mark - DELEGATES -
#pragma mark ServiceManagerDelegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api   {
    NSArray *officer_emails = [response objectForKey:@"officer_emails"];
    NSMutableArray *officer_models = [NSMutableArray arrayWithCapacity:officer_emails.count];
    for (NSString *email in officer_emails) {
        [officer_models addObject:[[[User alloc] initWithEmail:email] autorelease]];
    }
    self.officers = officer_models;
    [self.tableView reloadData];
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api {
    if ([api isEqualToString:@"employees/get_emails_by_location_ids"]) {
        UIAlertView *av;
        if (code == 404 || code == 500) {
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


#pragma mark - UITableViewDelegate & Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return officers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"CheckboxTableViewCellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
	}
    
    User *officer = [officers objectAtIndex:indexPath.row];
    cell.textLabel.text = officer.email;
    cell.accessoryType = officer.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath	{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	BOOL isSelected = (cell.accessoryType == UITableViewCellAccessoryNone);
	cell.accessoryType =  isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	User *officer = [officers objectAtIndex:indexPath.row];
    officer.isSelected = isSelected;
    
    if (isSelected )    {
        [self.selectedOfficers addObject:officer.email];
    }   else   {
        [self.selectedOfficers removeObject:officer.email];
    }
    self.nextButton.enabled = self.selectedOfficers.count;
}

@end
