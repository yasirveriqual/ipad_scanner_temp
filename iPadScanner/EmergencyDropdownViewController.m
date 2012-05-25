//
//  EmergencyDropdownViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 12/9/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
// 1

#import "EmergencyDropdownViewController.h"

@implementation EmergencyDropdownViewController

@synthesize emergencies, delegate;
@synthesize canEditEmergency;
@synthesize serviceManager;
@synthesize isDownloaded;
@synthesize message;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - Getter & Setter

- (void)setEmergencies:(NSArray *)emergencyList {
    if (emergencies) {
        [emergencies release];
    }
    emergencies = [emergencyList retain];
    [self.tableView reloadData];
}


#pragma mark - View lifecycle

- (void)loadView	{
	[super loadView];
	self.serviceManager = [ServiceManager managerWithDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(290.0, 220.0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (!isDownloaded) return 1;
    return [emergencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath	{
	UITableViewCell *tableViewCell;
	if (!self.isDownloaded)	{
		static NSString *CellIdentifier1 = @"Cell1";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
		
		if (cell == nil)	{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
			cell.textLabel.font = [UIFont systemFontOfSize:17];
		}
		cell.textLabel.text = message;
		tableViewCell = cell;
	}	else	{
		static NSString *CellIdentifier = @"Cell";
		
		EmergencyTableViewCell *cell = (EmergencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[NSBundle mainBundle] loadNibNamed:@"EmergencyTableViewCell" owner:self options:nil] objectAtIndex:0];
			cell.delegate = self;
		}
		Emergency *objEmergency = [emergencies objectAtIndex:indexPath.row];
		cell.lblEmergencyName.text = objEmergency.name;
		cell.cellIndex = indexPath.row;
		cell.isEditable = self.canEditEmergency;
		
		tableViewCell = cell;
    }
    return tableViewCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isDownloaded)	{
		Emergency *objEmergency = [emergencies objectAtIndex:indexPath.row];
		[delegate itemSelected:objEmergency];
	}
}

#pragma mark - Methods

- (void)pullEmergenciesFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate {
	NSComparisonResult result = [endDate compare:startDate];
	if (result == NSOrderedSame || result == NSOrderedDescending) {
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[dictionary setValue:[startDate rfc3339String] forKey:@"start_date"];
		[dictionary setValue:[endDate rfc3339String] forKey:@"end_date"];
		
		User *user = Session.user;
		NSLog(@"Group: %i", user.group);
		
		NSString *reqApiStr;
		if (user.group == UserGroupAdministrator) {
			reqApiStr = @"emergencies/get_by_date_range";
		}
		else {
			[dictionary setValue:Shared.email forKey:@"created_by_email"];
			reqApiStr = @"emergencies/get_by_date_range_and_email";
		}
		
		[self.serviceManager requestApi:reqApiStr forClass:@"emergency" usingObj:dictionary];
		
		
		self.isDownloaded = NO;
		self.message = @"Downloading...";
		[self.tableView reloadData];
	}	else	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Start Date must be lesser than End Date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alertView show];
		[alertView release];
	}
	
}

- (void)pullAllEmergencies	{
	NSMutableDictionary *dict =[NSMutableDictionary dictionary];
	[dict setObject:Shared.email forKey:@"created_by_email"];
	
	[self.serviceManager requestApi:@"emergencies/get_all" forClass:@"emergency" usingObj:dict];
	self.isDownloaded = NO;
	self.message = @"Downloading...";
	[self.tableView reloadData];
}


#pragma mark - EmergencyTableViewCellDelegate

- (void)editEmergencyAtIndex:(int)_cellIndex {
    [delegate editEmergency:[emergencies objectAtIndex:_cellIndex]];
}


#pragma mark - ServiceManagerDelegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api   {
	NSArray *arrEmergencies = [response objectForKey:@"emergencies"];
	NSMutableArray *emergencyList = [NSMutableArray arrayWithCapacity:arrEmergencies.count];
	for (NSDictionary *dict in arrEmergencies) {
		Emergency *emergency = [[[Emergency alloc] initWithDictionary:dict] autorelease];
		[emergencyList addObject:emergency];
	}
	self.emergencies = emergencyList;
	self.isDownloaded = self.emergencies.count;
	if (!self.isDownloaded)	{
		self.message = @"No Emergency found.";
	}
	[self.tableView reloadData];
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api	{
	self.isDownloaded = NO;
	if (code == 404)   {
		self.message = @"No Emergency found.";
    }	else	{
		self.message = @"Unable to complete request.";
	}
    [self.tableView reloadData];
}

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api	{
    self.isDownloaded = NO;
	self.message = @"Unable to complete request.";
	[self.tableView reloadData];
}


@end
