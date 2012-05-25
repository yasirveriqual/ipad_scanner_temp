//
//  SettingsTableViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/27/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "BaseLocationTableViewController.h"
#import "DeviceManager.h"

@implementation SettingsTableViewController

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    self.view.backgroundColor = [UIColor clearColor];
	
	self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 400.0);
    
    getBaseLocationTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    distanceDropDownTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"DropDownTableViewCell" owner:self options:nil] objectAtIndex:0] retain]; 
    fromDateDropDownTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"DateDropDownTableViewCell" owner:self options:nil] objectAtIndex:0] retain]; 
    toDateDropDownTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"DateDropDownTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    deviceDropDownTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"DropDownTableViewCell" owner:self options:nil] objectAtIndex:0] retain]; 
    
    fromDateDropDownTableViewCell.delegate = self;
    toDateDropDownTableViewCell.delegate = self;
    
    NSMutableDictionary *getBaseLocationDictionary = [NSMutableDictionary dictionary];
    [getBaseLocationDictionary setValue:@"Get Base Location:" forKey:@"label"];
    [getBaseLocationDictionary setValue:@"getBaseLocation" forKey:@"method"];
    getBaseLocationTableViewCell.dictionary = getBaseLocationDictionary;
    getBaseLocationTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    Shared *shared = [Shared instance];
    
	
	NSMutableDictionary *deviceDictionary = [NSMutableDictionary dictionary];
    [deviceDictionary setValue:@"Device:" forKey:@"label"];
    [deviceDictionary setValue:@"devices" forKey:@"source"];
	if (DeviceManager.deviceType != DeviceTypeUnknown)
        [deviceDictionary setValue:[NSString stringWithFormat:@"%i", DeviceManager.deviceType] forKey:@"value"];
    deviceDropDownTableViewCell.dictionary = deviceDictionary;
	
    
    NSMutableDictionary *distanceDictionary = [NSMutableDictionary dictionary];
    [distanceDictionary setValue:@"Distance:" forKey:@"label"];
    [distanceDictionary setValue:@"distances" forKey:@"source"];
    if (shared.selectedLocationIndex != NSUIntegerMax)
        [distanceDictionary setValue:[NSString stringWithFormat:@"%i", shared.selectedLocationIndex] forKey:@"value"];
    distanceDropDownTableViewCell.dictionary = distanceDictionary;
    
    NSMutableDictionary *fromDateDictionary = [NSMutableDictionary dictionary];
    [fromDateDictionary setValue:@"From Date:" forKey:@"label"];
    [fromDateDictionary setValue:[shared.fromDate stringValue] forKey:@"value"];
    fromDateDropDownTableViewCell.dictionary = fromDateDictionary;
    
    
    NSMutableDictionary *toDateDictionary = [NSMutableDictionary dictionary];
    [toDateDictionary setValue:@"To Date:" forKey:@"label"];
    [toDateDictionary setValue:[shared.toDate stringValue] forKey:@"value"];
    toDateDropDownTableViewCell.dictionary = toDateDictionary;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated    {
	
	NSString *fromDateString = fromDateDropDownTableViewCell.textField.text;
    NSString *toDateString = toDateDropDownTableViewCell.textField.text;
    
    Shared *shared = [Shared instance];
    
    shared.toDate = [NSDate dateFromString:toDateString];
    shared.fromDate = [NSDate dateFromString:fromDateString];
    
    float distanceInMeters = [[[distanceDropDownTableViewCell.textField.text componentsSeparatedByString:@" meters"] objectAtIndex:0] floatValue];
    shared.distance = distanceInMeters / 1000;
    
    shared.selectedLocationIndex = distanceDropDownTableViewCell.selectedIndex;
	
	[[DeviceManager currentDevice] disable];
	DeviceManager.deviceType = deviceDropDownTableViewCell.selectedIndex;
    
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Methods

- (void)getBaseLocation {
    NSString *distanceString = distanceDropDownTableViewCell.textField.text;
    if (distanceString.length > 0)    {
        
        float distanceInMeters = [[[distanceString componentsSeparatedByString:@" meters"] objectAtIndex:0] floatValue];
        float distanceInKiloMeters = distanceInMeters / 1000;
        
        
        BaseLocationTableViewController *viewController = [[BaseLocationTableViewController alloc] initWithDistance:distanceInKiloMeters];
        [super.navigationController pushViewController:viewController animated:YES];
		//[viewController release];
    }   
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Inforamtion!" 
                                                            message:@"Please select distance first."
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (section == 2) {
		return 1;
	}
	
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
	
	if (indexPath.section == 2)  {	// Device Management
			cell = deviceDropDownTableViewCell;
	}
    else if (indexPath.section == 1)  { 
        if (indexPath.row)  {
            cell = toDateDropDownTableViewCell;
        }   else    {
            cell = fromDateDropDownTableViewCell;
        }
    }
	else if (indexPath.section == 0) {
        if (indexPath.row)  {
            cell = getBaseLocationTableViewCell;
        }   else    {
            cell = distanceDropDownTableViewCell;
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath	{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dictionary = [[self.tableView cellForRowAtIndexPath:indexPath] valueForKey:@"dictionary"];
    if ([dictionary valueForKey:@"method"] != nil)
        [self performSelectorOnMainThread:NSSelectorFromString([dictionary valueForKey:@"method"]) withObject:nil waitUntilDone:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Base Location";
			break;
			
		case 1:
			return @"Default Scan Session Date Range";
			break;
			
		default:
			return @"Device Management";
			break;
	}
}

#pragma mark DateDropDownTableViewCellDelegate

- (BOOL)dateSelected:(NSDate *)selectedDate forDictionary:(NSDictionary *)dictionary {
    if ([[dictionary valueForKey:@"label"] isEqualToString:@"From Date:"])   {
        return YES;
    }
    
    NSString *fromDateString = fromDateDropDownTableViewCell.textField.text;
    
//    NSDate *toDate = [NSDate dateFromString:selectedValue];
    NSDate *toDate = selectedDate;
    NSDate *fromDate = [NSDate dateFromString:fromDateString];
    
    
    NSComparisonResult result = [toDate compare:fromDate];
    return (result == NSOrderedSame || result == NSOrderedDescending);
}

@end
