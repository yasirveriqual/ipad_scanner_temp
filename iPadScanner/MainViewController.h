//
//  MainViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/18/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "ViewController.h"
#import "ScanDetailView.h"
#import "CardScannerViewController.h"
#import "ScansDropDownController.h"
#import "NewScanViewController.h"
#import <MapKit/MKReverseGeocoder.h>
#import "Scan.h"
#import "MessageUI/MFMailComposeViewController.h"
#import "SettingsTableViewController.h"
#import "EmailView.h"
#import "ScanTableViewCell.h"
#import "RegisterViewController.h"
#import "MenuItemViewController.h"


@protocol MainViewControllerDelegate <NSObject>

- (void)didLogout;

@end


@interface MainViewController : ViewController <ScanDetailViewDelegate, UITableViewDelegate, UITableViewDataSource, NewScanViewControllerDelegate,  MFMailComposeViewControllerDelegate, EmailViewDelegate, UIPopoverControllerDelegate, ScanTableViewCellDelegate, RegisterViewControllerDelegate, MenuItemViewControllerDelegate>

#pragma mark Variables

@property (nonatomic, retain) NSMutableArray *scans;
@property (readwrite) int rowIndex;

@property (nonatomic, retain) Scan *selectedScan;
@property (nonatomic, retain) NSString *manualEmail;

@property (nonatomic, retain) NSTimer *menuTimer;

#pragma mark - UI

@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, retain) IBOutlet EmailView *emailView;
@property (nonatomic, retain) IBOutlet UIButton *manualScanButton;

@property (nonatomic, retain) SettingsTableViewController *settingsViewController;
@property (nonatomic, retain) UINavigationController *settingsNavigationController;
@property (nonatomic, retain) UIPopoverController *settingsPopoverController;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *scansBarButtonItem;


@property (nonatomic, retain) IBOutlet ScanDetailView *scansView;
@property (nonatomic, retain) IBOutlet UITableView *scansTableView;

@property (nonatomic, retain) UIPopoverController *dropDownPopover;
@property (nonatomic, retain) IBOutlet ScansDropDownController *dropDownController;

@property (nonatomic, assign) id <MainViewControllerDelegate> delegate;

@property (nonatomic, retain) UIPopoverController *menuItemPopover;
@property (nonatomic, retain) MenuItemViewController *menuItemViewController;


- (IBAction)settingsClicked;
- (IBAction)scansClicked;
- (IBAction)manualScanClicked;
- (IBAction)emailScans;

- (void)reloadScans;

@end
