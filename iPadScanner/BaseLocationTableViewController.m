//
//  BaseLocationTableViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/27/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "BaseLocationTableViewController.h"
#import "Location.h"
#import "Constants.h"
//#import "Bluetooth.h"
#import "DeviceManager.h"

@interface BaseLocationTableViewController (Private)
- (BOOL)checkFields;
@end


@implementation BaseLocationTableViewController

@synthesize location;
@synthesize locationName;
@synthesize distance;
@synthesize tableView;
@synthesize locations;


- (id)initWithDistance:(float)distanceValue {
    self = [super init];
    if (self) {
        self.distance = distanceValue;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)saveBaseLocation:(UIBarButtonItem *)barButton   {
    if ([self checkFields]) {
        NSString *newLocationName = locationTextFieldTableViewCell.textField.text;
        if (newLocationName.length > 0)   {
            saveBarButton = barButton;
            barButton.enabled = NO;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:newLocationName forKey:@"name"];
            
            if (isStreetAvailable) {
                [dict setObject:(streetLabelTableViewCell.valueLabel.text == nil)?@"":streetLabelTableViewCell.valueLabel.text forKey:@"street"];
				[dict setValue:[NSNumber numberWithBool:NO] forKey:@"editable_street"];
            }
            else {
                if (streetTextFieldTableViewCell.textField.text.length > 0) {
                    [dict setObject:streetTextFieldTableViewCell.textField.text forKey:@"street"];
					[dict setValue:[NSNumber numberWithBool:YES] forKey:@"editable_street"];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Enter Street" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                    [alertView release];
                }
            }
            
            [dict setObject:(cityLabelTableViewCell.valueLabel.text == nil)?@"":cityLabelTableViewCell.valueLabel.text forKey:@"city"];
            [dict setObject:(stateLabelTableViewCell.valueLabel.text == nil)?@"":stateLabelTableViewCell.valueLabel.text forKey:@"state"];
            [dict setObject:(latitudeLabelTableViewCell.valueLabel.text == nil)?@"":latitudeLabelTableViewCell.valueLabel.text forKey:@"latitude"];
            [dict setObject:(longitudeLabelTableViewCell.valueLabel.text == nil)?@"":longitudeLabelTableViewCell.valueLabel.text forKey:@"longitude"];
            [dict setObject:Shared.email forKey:@"created_by_email"];
            
            if ([Shared isNetworkAvailable]) {
                Location *objLocation = [[Location alloc] initWithDictionary:dict];
                [self.serviceManager requestApi:@"locations" usingObject:objLocation requestMethod:@"POST"];// requestMethod:@"POST"
                [objLocation release];
            }
            else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
                [av release];
            }
        }   else    {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter a new location name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
    }
}

- (void)addNewBaseLocation:(UIBarButtonItem *)barButton  {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveBaseLocation:)] autorelease];
        [cells replaceObjectAtIndex:0 withObject:locationTextFieldTableViewCell];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];    
}


#pragma mark - Private Methods

- (BOOL)checkFields {
    UIAlertView *av;
    if ([[stateLabelTableViewCell.valueLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0 && [[cityLabelTableViewCell.valueLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please wait while we load the information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;
    }
    else {
        return YES;
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Select Location";
	
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 400.0);
    
    downloadingTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    
    
    locationsDropDownTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"DropDownTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    
    locationTextFieldTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"TextFieldTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    streetTextFieldTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"TextFieldTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    
    streetLabelTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    cityLabelTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    stateLabelTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    latitudeLabelTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    longitudeLabelTableViewCell = [[[[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
    
    downloadingTableViewCell.textLabel.text = @"Downloading...";
    locationsDropDownTableViewCell.textLabel.text = @"Locations: ";
    locationTextFieldTableViewCell.textLabel.text = @"Name: ";
    locationTextFieldTableViewCell.textField.placeholder = @"Location Name";
    
    streetTextFieldTableViewCell.textLabel.text = @"Street: ";
    streetTextFieldTableViewCell.textField.placeholder = @"Street";
    
    streetLabelTableViewCell.textLabel.text = @"Street: ";
    cityLabelTableViewCell.textLabel.text = @"City: ";
    stateLabelTableViewCell.textLabel.text = @"State: ";
    latitudeLabelTableViewCell.textLabel.text = @"Latitude: ";
    longitudeLabelTableViewCell.textLabel.text = @"Longitude: ";
    
    cells =[[NSMutableArray array] retain];
    [cells addObject:downloadingTableViewCell];
    [cells addObject:streetLabelTableViewCell];
    [cells addObject:cityLabelTableViewCell];
    [cells addObject:stateLabelTableViewCell];
    [cells addObject:latitudeLabelTableViewCell];
    [cells addObject:longitudeLabelTableViewCell];
    
    
    //[Bluetooth turnOff];
	[[DeviceManager currentDevice] disable];
	
    self.location = [LocationManager getInstance].userLocation;
    
    NSMutableDictionary *dictioanry = [NSMutableDictionary dictionary];
    [dictioanry setValue:[NSString stringWithFormat:@"%f", self.location.coordinate.latitude] forKey:@"latitude"];
    [dictioanry setValue:[NSString stringWithFormat:@"%f", self.location.coordinate.longitude] forKey:@"longitude"];
    [dictioanry setValue:[NSString stringWithFormat:@"%f", self.distance/4] forKey:@"distance"];
    [self.serviceManager requestApi:@"locations/get_existing_locations" 
                           forClass:@"location" 
                           usingObj:dictioanry];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped] ;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.view addSubview:tableView];
    [tableView release];

    
    if (self.location!=nil) {
        MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:self.location.coordinate];
        [geocoder setDelegate:self];
        [geocoder start];
        
    }
    
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	[self.serviceManager cancel];
	self.serviceManager.delegate = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    locationsDropDownTableViewCell.textField.text = [Shared instance].baseLocation.name;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (locationsDropDownTableViewCell.selectedIndex != NSUIntegerMax){
        NSUInteger selectedLocationIndex = locationsDropDownTableViewCell.selectedIndex;
        [Shared instance].baseLocation = (Location *)[self.locations objectAtIndex:selectedLocationIndex];
        [[Shared instance] saveBaseLocation];
    }
    
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = (UITableViewCell *)[cells objectAtIndex:indexPath.row];
        
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tblView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark MK Reverse Geocoder Delegates

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    [geocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSDictionary *addrsDict = [placemark addressDictionary];
    
    if ([addrsDict valueForKey:@"Street"] == nil) {
        isStreetAvailable = NO;
        [cells replaceObjectAtIndex:1 withObject:streetTextFieldTableViewCell];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
		isStreetAvailable = YES;
        streetLabelTableViewCell.valueLabel.text = [addrsDict objectForKey:@"Street"];
    }
    
    cityLabelTableViewCell.valueLabel.text = [addrsDict objectForKey:@"City"];
    stateLabelTableViewCell.valueLabel.text = [addrsDict objectForKey:@"State"];
    latitudeLabelTableViewCell.valueLabel.text = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
    longitudeLabelTableViewCell.valueLabel.text = [NSString stringWithFormat:@"%f", self.location.coordinate.longitude];
    
    [self.tableView reloadData];
}


#pragma mark - Service Manager Delegates

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api {
    if ([api isEqualToString:@"locations/get_existing_locations"])   {
        self.locations = [Location locationsFromArray:[response valueForKey:@"locations"]];
        
        NSMutableArray *locationNames = [NSMutableArray array];
        for (Location *loc in locations) {
            [locationNames addObject:loc.name];
        }
        locationsDropDownTableViewCell.source = locationNames;
        [cells replaceObjectAtIndex:0 withObject:locationsDropDownTableViewCell];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewBaseLocation:)] autorelease];
        
    }
    if ([api isEqualToString:@"locations"]) {
        
        NSString *newLocName = locationTextFieldTableViewCell.textField.text;
        
		Location *newLocation = [[[Location alloc] init] autorelease];
		
        newLocation.ID = [[[response objectForKey:@"location"] valueForKey:@"id"] intValue];
        newLocation.name = newLocName;
        
        if (isStreetAvailable) {
            newLocation.street = (streetLabelTableViewCell.valueLabel.text == nil)? @"" : streetLabelTableViewCell.valueLabel.text;
        }
        else {
            newLocation.street = streetTextFieldTableViewCell.textField.text;
        }
        
        
        newLocation.city = (cityLabelTableViewCell.valueLabel.text == nil)? @"" : cityLabelTableViewCell.valueLabel.text;
        newLocation.state = (stateLabelTableViewCell.valueLabel.text == nil)? @"" : stateLabelTableViewCell.valueLabel.text;
        newLocation.latitude = (latitudeLabelTableViewCell.valueLabel.text == nil)? @"" : latitudeLabelTableViewCell.valueLabel.text;
        newLocation.longitude = (longitudeLabelTableViewCell.valueLabel.text == nil)? @"" : longitudeLabelTableViewCell.valueLabel.text;
        
        [Shared instance].baseLocation = newLocation;
        [[Shared instance] saveBaseLocation];
        

        if (!isStreetAvailable) {
            streetLabelTableViewCell.valueLabel.text = streetTextFieldTableViewCell.textField.text;
            [cells replaceObjectAtIndex:1 withObject:streetLabelTableViewCell];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
        
        NSMutableArray *newLocations = [NSMutableArray arrayWithArray:self.locations];
        [newLocations insertObject:newLocation atIndex:0];
        self.locations = newLocations;
        
        NSMutableArray *newLocationNames = [NSMutableArray arrayWithArray:locationsDropDownTableViewCell.source];
        [newLocationNames insertObject:newLocName atIndex:0];
        
        locationTextFieldTableViewCell.textField.text = @"";
        
         locationsDropDownTableViewCell.source = newLocationNames;
        [locationsDropDownTableViewCell reloadItems];
         locationsDropDownTableViewCell.textField.text = newLocName;
         [cells replaceObjectAtIndex:0 withObject:locationsDropDownTableViewCell];
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewBaseLocation:)] autorelease];
        
    }
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api {
    if ([api isEqualToString:@"locations/get_existing_locations"] && code==404)   {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveBaseLocation:)] autorelease];
        [cells replaceObjectAtIndex:0 withObject:locationTextFieldTableViewCell];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([api isEqualToString:@"locations"]) {
        saveBarButton.enabled = YES;
        
        UIAlertView *av;
        
        if (code == 500) {
            av = [[UIAlertView alloc] initWithTitle:[response valueForKey:@"status"] message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
        else if (code == 501) {
            NSArray *errors = [response objectForKey:@"errors"];
            av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[errors objectAtIndex:0] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api {
    if (error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}



@end
