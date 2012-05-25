//
//  ReportBasicInformationViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/19/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ReportBasicInformationViewController.h"
#import "ReportOfficersViewController.h"
#import "ReportScanSessionsViewController.h"
#import "Location.h"

@interface ReportBasicInformationViewController ()  {
    BOOL isEndDate;
}
@end

@implementation ReportBasicInformationViewController

@synthesize startDateTextField, endDateTextField, emergencyTextField;

@synthesize datePopover;
@synthesize emergencyPopover;

@synthesize dateDropdownController;
@synthesize emergencyDropdownController;

@synthesize emergencies;
@synthesize locations;

@synthesize selectedEmergency;

@synthesize startDateImageView;
@synthesize endDateImageView;
@synthesize emergencyImageView;

@synthesize tableView;

@synthesize emergencyButton;
@synthesize nextButton;

@synthesize selectedLocations;


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
    self.emergencies = [NSArray array];
    self.locations = [NSArray array];
    self.selectedLocations = [NSMutableArray array];
    
    self.emergencyButton.enabled = NO;
    self.nextButton.enabled = NO;
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

#pragma mark - IBActions

- (IBAction)selectStartDate {
    [self.view endEditing:YES];
    dateDropdownController = nil;
    
    if (dateDropdownController == nil) {
        self.dateDropdownController = [[[DatePickerDropdownViewController alloc] initWithNibName:@"DatePickerDropdownViewController" bundle:nil textField:self.startDateTextField] autorelease];
        self.dateDropdownController.delegate = self;
        
        self.datePopover = [[[UIPopoverController alloc] initWithContentViewController:dateDropdownController] autorelease];
    }
    
    [self.datePopover presentPopoverFromRect:CGRectMake(self.startDateImageView.frame.origin.x+8, (self.startDateImageView.frame.origin.y+self.startDateImageView.frame.size.height-5), 290, 250) inView:self.contentView permittedArrowDirections:0 animated:YES];
    isEndDate = NO;
}

- (IBAction)selectEndDate   {
    [self.view endEditing:YES];
    
    dateDropdownController = nil;
    
    if (dateDropdownController == nil) {
        self.dateDropdownController = [[[DatePickerDropdownViewController alloc] initWithNibName:@"DatePickerDropdownViewController" bundle:nil textField:self.endDateTextField] autorelease];
        self.dateDropdownController.delegate = self;
        
        self.datePopover = [[[UIPopoverController alloc] initWithContentViewController:dateDropdownController] autorelease];
    }
    
    [self.datePopover presentPopoverFromRect:CGRectMake(self.endDateImageView.frame.origin.x+8, (self.endDateImageView.frame.origin.y+self.endDateImageView.frame.size.height-5), 290, 250) inView:self.contentView permittedArrowDirections:0 animated:YES];
    isEndDate = YES;
}

- (IBAction)selectEmergency {
    [self.view endEditing:YES];
    
    if (emergencyPopover == nil) {
        self.emergencyDropdownController = [[[EmergencyDropdownViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.emergencyPopover = [[[UIPopoverController alloc] initWithContentViewController:self.emergencyDropdownController] autorelease];
        self.emergencyDropdownController.emergencies = self.emergencies;
        self.emergencyDropdownController.delegate = self;
        self.emergencyDropdownController.canEditEmergency = NO;
        
    }
    
    if ([emergencyPopover isPopoverVisible])  {
        [emergencyPopover dismissPopoverAnimated:YES];
    }   
	else {
			[self.emergencyPopover presentPopoverFromRect:CGRectMake(self.emergencyImageView.frame.origin.x+8, (self.emergencyImageView.frame.origin.y+self.emergencyImageView.frame.size.height+10), 290, 220) inView:self.contentView permittedArrowDirections:0 animated:YES];
			
			NSString *startDateString = self.startDateTextField.text;
			NSString *endDateString = self.endDateTextField.text;
			
			[self.emergencyDropdownController pullEmergenciesFromStartDate:[NSDate dateFromString:startDateString] 
																 toEndDate:[NSDate dateFromString:endDateString]];
    }
}

- (IBAction)nextClicked {
    User *user = Session.user;
    NSLog(@"Group: %i", user.group);
	ReportContentViewController *viewController = nil;
    if (user.group == UserGroupAdministrator) {
        viewController = [[ReportOfficersViewController alloc] initWithLocations:selectedLocations];
    }   
	else if (user.group == UserGroupFiremarshal)  {
        viewController = [[ReportScanSessionsViewController alloc] initWithLocations:selectedLocations];
    }
	[super.navigationController pushViewController:viewController animated:YES];
	[viewController release];
    
}

#pragma mark - DELEGATES -

#pragma mark EmergencyDropdownViewControllerDelegate

- (void)itemSelected:(Emergency *)item {
    self.selectedEmergency = item;
	[Shared instance].reportEmergencyId = [NSString stringWithFormat:@"%i", selectedEmergency.ID];

        self.emergencyTextField.text = self.selectedEmergency.name;
        [self.emergencyPopover dismissPopoverAnimated:YES];
        
        [self.serviceManager requestApi:@"locations/get_by_emergency_id" forClass:@"emergency" usingObj:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i", selectedEmergency.ID] forKey:@"id"]];
    self.locations = [NSArray array];
    [self.selectedLocations removeAllObjects];
    self.nextButton.enabled = NO;
    [self.tableView reloadData];
}

#pragma mark DatePickerDropdownViewControllerDelegate

- (void)dateSelected:(NSDate *)selectedValue  {
    if (isEndDate)  {
        self.endDateTextField.text = [selectedValue stringValue];
    }
    
    if (self.startDateTextField.text.length > 0 && self.endDateTextField.text.length > 0)   {
        NSString *startDateString = self.startDateTextField.text;
        NSString *endDateString = self.endDateTextField.text;
        
        NSDate *startDate = [NSDate dateFromString:startDateString];
        NSDate *endDate = [NSDate dateFromString:endDateString];
        
        NSComparisonResult result = [endDate compare:startDate];
        if (result == NSOrderedDescending || result == NSOrderedSame)	{
			emergencyButton.enabled = YES;
		}
		else	{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Start Date must be less than End Date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
			emergencyButton.enabled = NO;
        }
    }
}


#pragma mark - UITableViewDelegate & Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"CheckboxTableViewCellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
	}
    
    Location *location = [locations objectAtIndex:indexPath.row];
    cell.textLabel.text = location.name;
    cell.accessoryType = location.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath	{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	BOOL isSelected = (cell.accessoryType == UITableViewCellAccessoryNone);
	cell.accessoryType =  isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	Location *location = [locations objectAtIndex:indexPath.row];
    location.isSelected = isSelected;
    
    if (isSelected)    {
        [self.selectedLocations addObject:[NSNumber numberWithInt:location.ID]];
    }   else   {
        for (NSNumber *num in self.selectedLocations)    {
            if (location.ID == [num intValue])  {
                [self.selectedLocations removeObject:num];
                break;
            }
        }
    }
    self.nextButton.enabled = self.selectedLocations.count;
}

#pragma mark ServiceManagerDelegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api   {
//    if ([api isEqualToString:@"emergencies/get_by_date_range"])   {
//        
//        NSArray *arrEmergencies = [response objectForKey:@"emergencies"];
//        NSMutableArray *emergencyList = [NSMutableArray arrayWithCapacity:arrEmergencies.count];
//        for (NSDictionary *dict in arrEmergencies) {
//            Emergency *emergency = [[[Emergency alloc] initWithDictionary:dict] autorelease];
//            [emergencyList addObject:emergency];
//        }
//        self.emergencies = emergencyList;
//        if (self.emergencyDropdownController != nil)    {
//            emergencyDropdownController.emergencies = emergencies;
//            [emergencyDropdownController.tableView reloadData];
//        }
////        self.emergencyButton.enabled = YES;
//    }   
//    
//    else 
	if ([api isEqualToString:@"locations/get_by_emergency_id"])    {
        NSArray *arrLocations = [response objectForKey:@"locations"];
        NSMutableArray *locationList = [NSMutableArray arrayWithCapacity:arrLocations.count];
        for (NSDictionary *dict in arrLocations) {
            Location *location = [[[Location alloc] initWithDictionary:dict] autorelease];
            [locationList addObject:location];
        }
        self.locations = locationList;
        [tableView reloadData];
        [self.selectedLocations removeAllObjects];
    }
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api {
	//[api isEqualToString:@"emergencies/get_by_date_range"] || 
    if ([api isEqualToString:@"locations/get_by_emergency_id"]) {
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

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api  {
    if (error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

@end
