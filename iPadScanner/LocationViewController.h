//
//  LocationViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 10/23/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "ViewController.h"
#import "DatePickerDropdownViewController.h"
#import "EmergencyDropdownViewController.h"
#import "Emergency.h"

@interface LocationViewController : ViewController <MKReverseGeocoderDelegate, EmergencyDropdownViewControllerDelegate,DatePickerDropdownViewControllerDelegate, MKMapViewDelegate> {
    CLLocationCoordinate2D locCoordinate;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (nonatomic, retain) IBOutlet UIView *configurationView;
@property (nonatomic, retain) IBOutlet UIButton *panelButton;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UITextField *startDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *endDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *emergencyTextField;
@property (nonatomic, retain) UIPopoverController *datePopover;
@property (nonatomic, retain) DatePickerDropdownViewController *dateDropdownController;
@property (nonatomic, retain) IBOutlet UIImageView *startDateImageView;
@property (nonatomic, retain) IBOutlet UIImageView *endDateImageView;
@property (nonatomic, retain) UIPopoverController *emergencyPopover;
@property (nonatomic, retain) EmergencyDropdownViewController *emergencyDropdownController;
@property (nonatomic, retain) IBOutlet UIImageView *emergencyImageView;
@property (nonatomic, retain) NSArray *emergencies;
@property (nonatomic, retain) IBOutlet UIButton *emergencyButton;
@property (nonatomic, retain) IBOutlet UIButton *showButton;
@property (nonatomic, retain) Emergency *selectedEmergency;

@property (nonatomic, retain) NSMutableArray *baseLocationIDs;

- (IBAction)selectStartDate;
- (IBAction)selectEndDate;
- (IBAction)selectEmergency;
- (IBAction)showButtonClicked;
- (IBAction)changeType;

- (IBAction)panelButtonClicked;

@end
