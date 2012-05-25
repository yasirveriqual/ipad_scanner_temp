//
//  BaseLocationTableViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/27/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <MapKit/MKReverseGeocoder.h>
#import "LocationManager.h"
#import "LabelTableViewCell.h"
#import "DropDownTableViewCell.h"
#import "TextFieldTableViewCell.h"


@interface BaseLocationTableViewController : ViewController  <MKReverseGeocoderDelegate, UITableViewDelegate, UITableViewDataSource> {
    TableViewCell *downloadingTableViewCell;
    DropDownTableViewCell *locationsDropDownTableViewCell;
    TextFieldTableViewCell *locationTextFieldTableViewCell;
    TextFieldTableViewCell *streetTextFieldTableViewCell;
    LabelTableViewCell *streetLabelTableViewCell;
    LabelTableViewCell *cityLabelTableViewCell;
    LabelTableViewCell *stateLabelTableViewCell;
    LabelTableViewCell *latitudeLabelTableViewCell;
    LabelTableViewCell *longitudeLabelTableViewCell;
    NSMutableArray *cells;
    
    UIBarButtonItem *saveBarButton;
    
    BOOL isStreetAvailable;
}

@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, readwrite) float distance;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *locations;


- (id)initWithDistance:(float)distance;

@end
