//
//  SessionLocationViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 12/19/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "SessionLocationViewController.h"
#import "Constants.h"


@interface SessionLocationViewController (Private)
- (void)zoomToFitMapAnnotations;
@end

@implementation SessionLocationViewController

@synthesize mapView;
@synthesize scanModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scanModel:(Scan *)scan
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scanModel = scan;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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



#pragma mark - Service Manager Delegate -

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api {
	NSLog(@"RESPONSE: %@", response);
	
    if ([api isEqualToString:@"locations/get_scan_locations_by_distance"]) {
                
        NSDictionary *locationDict = [response objectForKey:@"location"];
        NSDictionary *baseLocationDict = [locationDict objectForKey:@"base_location"];
        NSArray *otherLocations = [locationDict objectForKey:@"others"];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        Location *objLocation = [[Location alloc] initWithDictionary:baseLocationDict];
        [arr addObject:objLocation];
        [objLocation release];
        
        for (NSDictionary *dict in otherLocations) {
            Location *objLocation = [[Location alloc] initWithDictionary:dict];
            [arr addObject:objLocation];
            [objLocation release];
        }
        
        
        [mapView addAnnotations:arr];
        [arr release];
                
        [self zoomToFitMapAnnotations];
    }
}


- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api {
    if ([api isEqualToString:@"locations/get_scan_locations_by_distance"]) {
        UIAlertView *av;
        if (code == 404) {
            av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No location against selected scan session" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
        else if (code == 500) {
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

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api {
    if (error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Session Map View";
    
    if ([Shared isNetworkAvailable]) {
        float baseLocationDistance = Shared.distance;
        if (baseLocationDistance > 0)   {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%d", self.scanModel.ID] forKey:@"id"];
            float distance25Percent = baseLocationDistance/4;
            [dict setObject:[NSString stringWithFormat:@"%f", distance25Percent] forKey:@"distance"];
            [self.serviceManager requestApi:@"locations/get_scan_locations_by_distance" forClass:@"scan" usingObj:dict];
            [dict release];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                                message:@"Please set distance to base location in settings first." 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

- (void)viewWillDisappear:(BOOL)animated    {
    [super viewWillDisappear:animated];
	mapView.delegate = nil;
    [self.serviceManager cancel];
    self.serviceManager.delegate = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id <MKAnnotation>)annotation	{
	MKPinAnnotationView *annotationView = nil;
    
    Location *location = (Location *)annotation;
    NSLog(@"ID: %i", location.ID);
	if (location.ID > 0)	{ // IS BASE LOCATION?
		static NSString *identifier = @"BaseLocationPinAnnotation";
		
		annotationView = (MKPinAnnotationView *) [mView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if (annotationView == nil) {
			annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
		} else {
			annotationView.annotation = annotation;
		}
		annotationView.enabled = YES;
		annotationView.canShowCallout = YES;
		
		annotationView.pinColor = MKPinAnnotationColorGreen;
	}   else	{
		
		static NSString *identifier = @"OtherPinAnnotation";
		
		annotationView = (MKPinAnnotationView *) [mView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if (annotationView == nil) {
			annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
			annotationView.animatesDrop = YES;
		} else {
			annotationView.annotation = annotation;
		}
		annotationView.enabled = YES;
		annotationView.canShowCallout = YES;
		
		annotationView.pinColor = MKPinAnnotationColorRed;
	}
	return annotationView;
}

@end
