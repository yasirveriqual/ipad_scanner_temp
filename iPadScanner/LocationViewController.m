//
//  LocationViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 10/23/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "LocationViewController.h"
#import "UserLocation.h"
#import "LocationManager.h"


@interface LocationViewController ()  {
    BOOL isEndDate;
}
@end

@implementation LocationViewController

@synthesize typeSegmentedControl;
@synthesize configurationView;
@synthesize panelButton;
@synthesize mapView;
@synthesize startDateTextField, endDateTextField, emergencyTextField;
@synthesize datePopover;
@synthesize emergencyPopover;
@synthesize dateDropdownController;
@synthesize emergencyDropdownController;
@synthesize emergencies;
@synthesize startDateImageView;
@synthesize endDateImageView;
@synthesize emergencyImageView;
@synthesize emergencyButton;
@synthesize showButton;
@synthesize selectedEmergency;
@synthesize baseLocationIDs;

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


#pragma mark - Methods -
- (void)showConfigurationPanel:(BOOL)yesOrNo	{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelegate:self];
	CGRect frame = self.configurationView.frame;
	frame.origin.x = yesOrNo ? 674 : 994;
	self.configurationView.frame = frame;
	[UIView commitAnimations];
}

- (void)zoomToFitMapAnnotations
{
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(Location *annotation in mapView.annotations)
    {
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
		topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
		bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
		bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
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
    
    [self.datePopover presentPopoverFromRect:CGRectMake(self.startDateImageView.frame.origin.x+8, (self.startDateImageView.frame.origin.y+self.startDateImageView.frame.size.height-5), 290, 250) inView:self.configurationView permittedArrowDirections:0 animated:YES];
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
    
    [self.datePopover presentPopoverFromRect:CGRectMake(self.endDateImageView.frame.origin.x+8, (self.endDateImageView.frame.origin.y+self.endDateImageView.frame.size.height-5), 290, 250) inView:self.configurationView permittedArrowDirections:0 animated:YES];
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
		[self.emergencyPopover presentPopoverFromRect:CGRectMake(self.emergencyImageView.frame.origin.x+8, (self.emergencyImageView.frame.origin.y+self.emergencyImageView.frame.size.height+10), 290, 220) inView:self.configurationView permittedArrowDirections:0 animated:YES];
		
		NSString *startDateString = self.startDateTextField.text;
		NSString *endDateString = self.endDateTextField.text;
		
		[self.emergencyDropdownController pullEmergenciesFromStartDate:[NSDate dateFromString:startDateString] 
															 toEndDate:[NSDate dateFromString:endDateString]];
    }
}

- (IBAction)showButtonClicked {
	[self.serviceManager requestApi:[NSString stringWithFormat:@"locations/get_base_locations_and_scans_by_emergencey_id/%i", self.selectedEmergency.ID] forClass:@"location" usingObj:nil];
	[self panelButtonClicked];
}

- (IBAction)changeType	{
	mapView.mapType = typeSegmentedControl.selectedSegmentIndex;
}

- (IBAction)panelButtonClicked	{
	panelButton.selected = !panelButton.selected;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelegate:self];
	CGRect frame = self.configurationView.frame;
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))	{
		frame.origin.x = panelButton.selected ? 674 : 994;
		frame.size.height = 704;
	}	else	{
		frame.origin.x = panelButton.selected ? 418 : 738;
		frame.size.height = 960;
	}
	
	self.configurationView.frame = frame;
	[UIView commitAnimations];
}


#pragma mark ServiceManagerDelegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api	{
	if ([api hasPrefix:@"locations/get_base_locations_and_scans_by_emergencey_id"]) {
		
		[mapView removeAnnotations:mapView.annotations];
		
		NSArray *locations = [response objectForKey:@"locations"];
		if (locations.count)	{
			for (NSDictionary *locationDict in locations) {
				NSDictionary *baseLocationDict = [locationDict objectForKey:@"base_location"];
				NSArray *otherLocations = [locationDict objectForKey:@"others"];
				
				
				NSMutableArray *arr = [[NSMutableArray alloc] init];
				Location *baseLocation = [[Location alloc] initWithDictionary:baseLocationDict];
				[arr addObject:baseLocation];
				[baseLocation release];
				[self.baseLocationIDs addObject:[NSString stringWithFormat:@"%i", baseLocation.ID]];
				
				for (NSDictionary *dict in otherLocations) {
					Location *objLocation = [[Location alloc] initWithDictionary:dict];
					objLocation.ID = baseLocation.ID;
					[arr addObject:objLocation];
					[objLocation release];
				}
				
				
				[mapView addAnnotations:arr];
				[arr release];
			}	
		}	else	{
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No location found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[av show];
			[av release];
		}
        [self zoomToFitMapAnnotations];
    }
}

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api	{
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to complete your request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[av show];
	[av release];
	[mapView removeAnnotations:mapView.annotations];
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api	{
	UIAlertView *av;
	if (code == 404)	{
		av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No location found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
	}	else	{
		av = [[UIAlertView alloc] initWithTitle:@"Error" message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	[av show];
	[av release];
	[mapView removeAnnotations:mapView.annotations];
}

#pragma mark EmergencyDropdownViewControllerDelegate

- (void)itemSelected:(Emergency *)item {
    self.selectedEmergency = item;
	
	self.emergencyTextField.text = self.selectedEmergency.name;
	[self.emergencyPopover dismissPopoverAnimated:YES];
    self.showButton.enabled = YES;
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Start Date must be lesser than End Date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
			emergencyButton.enabled = NO;
        }
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id <MKAnnotation>)annotation	{
	MKPinAnnotationView *annotationView = nil;
	if (annotation != mapView.userLocation)	{
		Location *location = (Location *)annotation;
		static NSString *identifier = @"BaseLocationPinAnnotation";
		
		annotationView = (MKPinAnnotationView *) [mView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if (annotationView == nil) {
			annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
		} else {
			annotationView.annotation = annotation;
		}
		annotationView.enabled = YES;
		annotationView.canShowCallout = YES;
		if (baseLocationIDs.count)	{
			annotationView.pinColor = [baseLocationIDs indexOfObject:[NSString stringWithFormat:@"%i", location.ID]] % 3;
		}
	}
	return annotationView;
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
	self.baseLocationIDs = [NSMutableArray array];
    [super viewDidLoad];
    self.title = @"Current Location";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
