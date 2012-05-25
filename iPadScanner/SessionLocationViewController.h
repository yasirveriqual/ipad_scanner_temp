//
//  SessionLocationViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 12/19/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "Scan.h"

@interface SessionLocationViewController : ViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) Scan *scanModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scanModel:(Scan *)scan;

@end
