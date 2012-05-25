//
//  MainViewController.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/18/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "MainViewController.h"
#import "CardScannerViewController.h"
#import "Scan.h"
#import "ScanDetailView.h"
#import "EmployeeTableViewCell.h"
#import "LocationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PDFView.h"
#import "NSString+Extras.h"
#import "Location.h"
#import "Emergency.h"
#import "ReportGenerationViewController.h"
#import "SessionLocationViewController.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "LocationManager.h"

@interface MainViewController (Private)
- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
- (void)sendEmailDialogWithViewController:(UIViewController*)viewController 
                                        title:(NSString*)mailTitle body:(NSString*)mailBody 
                                   attachment:(NSData*)attachmentData attachmentMime:(NSString*)attachmentMime attachmentFile:(NSString*)attachmentFile
                               attachmentType:(NSString*)attachmentType;
@end


@implementation MainViewController

@synthesize delegate;
@synthesize menuTimer;
@synthesize containerView;
@synthesize manualScanButton;
@synthesize scans;
@synthesize settingsBarButtonItem;
@synthesize scansBarButtonItem;
@synthesize emailView;
@synthesize scansView;
@synthesize scansTableView;
@synthesize dropDownPopover;
@synthesize dropDownController;
@synthesize rowIndex;
@synthesize manualEmail;
@synthesize selectedScan;
@synthesize settingsNavigationController;
@synthesize settingsViewController;
@synthesize settingsPopoverController;
@synthesize backgroundImageView;
@synthesize menuItemPopover = _menuItemPopover;
@synthesize menuItemViewController = _menuItemViewController;


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

- (void)loadView {
    [super loadView];
    scansView.delegate = self;
    self.navigationItem.rightBarButtonItem = settingsBarButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Emergency Assembly";
	[[DeviceManager currentDevice] enable];
    
    self.scans = [[[NSMutableArray alloc] init] autorelease];
    [self reloadScans];
	
}

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
	
	[[DeviceManager currentDevice] enable];
	self.serviceManager.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration   {
    BOOL isLandscape = (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    NSString  *imageNamed = [NSString stringWithFormat:@"background-%@.png", isLandscape ? @"L" : @"P"];
    backgroundImageView.image = [UIImage imageNamed:imageNamed];
    [scansView changeOrientationToLandscape:isLandscape];
	self.navigationItem.leftBarButtonItem = isLandscape ? nil : scansBarButtonItem;
    [self.dropDownPopover dismissPopoverAnimated:NO];
}

- (void)dealloc {
	self.menuItemPopover = nil;
	self.menuItemViewController = nil;
    [scans release];
    [super dealloc];
}


- (void)showMenuView:(BOOL)yesOrNo  {
    [UIView  beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	CGRect containerFrame = self.containerView.frame;
	containerFrame.origin.x = yesOrNo ? 193 : 0;
	self.containerView.frame = containerFrame;
	[UIView commitAnimations];
    if (!yesOrNo)   {
        [self.menuTimer invalidate];
    }
}

#pragma mark Email

- (void)sendEmailDialogWithViewController:(UIViewController*)viewController 
                                    title:(NSString*)mailTitle body:(NSString*)mailBody 
                               attachment:(NSData*)attachmentData attachmentMime:(NSString*)attachmentMime attachmentFile:(NSString*)attachmentFile
                           attachmentType:(NSString*)attachmentType {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	if (picker == nil) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please configure your email settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av release];
		return;
	}
    
	[[DeviceManager currentDevice] disable];
    
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.mailComposeDelegate = self;
	
	[picker setSubject:mailTitle];
	[picker setMessageBody:mailBody isHTML:NO];
	[picker addAttachmentData:attachmentData mimeType:attachmentMime fileName:attachmentFile];
	[picker becomeFirstResponder];
    
	[viewController presentModalViewController:picker animated:YES];
	[picker release];
}


#pragma mark PDF Generation

- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
   
    [aView.layer renderInContext:pdfContext];
    
    UIGraphicsEndPDFContext();
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    
    [self sendEmailDialogWithViewController:self title:@"IPad Scanner" body:@"" attachment:pdfData attachmentMime:@"application/pdf" attachmentFile:@"Scans.pdf" attachmentType:@""];
}


#pragma mark - IBAction -




- (IBAction)settingsClicked {
    [self.view endEditing:YES];
    
    if (self.settingsViewController == nil)    {
        self.settingsViewController = [[[SettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        self.settingsNavigationController = [[[UINavigationController alloc] initWithRootViewController:settingsViewController] autorelease];
        self.settingsPopoverController =[[[UIPopoverController alloc] initWithContentViewController:settingsNavigationController] autorelease];
        self.settingsPopoverController.delegate = self;
        [self.settingsPopoverController presentPopoverFromBarButtonItem:settingsBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }   
    else {
        [self.settingsPopoverController dismissPopoverAnimated:YES];
        self.settingsViewController = nil;
    }
    
    
    [self.dropDownPopover dismissPopoverAnimated:YES];
}

- (IBAction)scansClicked {
    [self.view endEditing:YES];
    
	if (self.dropDownPopover == nil)
        self.dropDownPopover = [[[UIPopoverController alloc] initWithContentViewController:dropDownController] autorelease];

	if (!self.dropDownPopover.isPopoverVisible)
		[self.dropDownPopover presentPopoverFromBarButtonItem:scansBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	else	{
		[self.dropDownPopover dismissPopoverAnimated:YES];
		self.dropDownPopover = nil;
	}
		
}

- (IBAction)manualScanClicked {
	UIAlertView *alertView;
	
	if (Shared.distance > 0) {
		Location *bLocation = [Shared instance].baseLocation;
		if (bLocation.ID) {
			NSArray *employees = scansView.scan.employees;
            if (employees.count)    {
                Employee *employee = [employees objectAtIndex:0];
				
                if (bLocation.ID == employee.locationID)  
                {
                    [self.view endEditing:YES];
					
					[[DeviceManager currentDevice] disable];
					
					[self.view bringSubviewToFront:emailView];
					emailView.hidden = NO;
                }   
                else    
                {
                    [scansView.employeesTableView reloadData];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                                        message:@"The scan session has been locked because base location is changed." 
                                                                       delegate:nil 
                                                              cancelButtonTitle:@"OK" 
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
            }   
            else    
            {
                [self.view endEditing:YES];
				[[DeviceManager currentDevice] disable];
				[self.view bringSubviewToFront:emailView];
				emailView.hidden = NO;
            }

		}
		else {
			alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
																message:@"Please add or select base location from settings." 
															   delegate:nil 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
	else {
		alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                            message:@"Please set distance to base location in settings first." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

- (IBAction)emailScans {
    //[self menuClicked];
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"PDFView" owner:self options:nil];
    PDFView *pdfView = (PDFView *)[nibs objectAtIndex:0];
    pdfView.scan = self.selectedScan;
    [self createPDFfromUIView:pdfView saveToDocumentsWithFileName:@"Scans.pdf"];
}


#pragma mark MF Mail Compose View Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	[[DeviceManager currentDevice] enable];
	[controller dismissModalViewControllerAnimated:YES];
}


#pragma mark UITableView Delegate & Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return scans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"ScanTableViewCell";
    
    ScanTableViewCell *cell = (ScanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)	{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ScanTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    Scan *scan = [scans objectAtIndex:indexPath.row];
    
    cell.textLabel.text = scan.scanSessionName;
    cell.cellIndex = indexPath.row;
	
	
	UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [disclosureButton addTarget:self action:@selector(discloseDetails:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = disclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.rowIndex = indexPath.row;
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
	if ([tableView isEqual:dropDownController.tableView])	{
        [dropDownPopover dismissPopoverAnimated:YES];
	}	
	
    self.selectedScan = [scans objectAtIndex:indexPath.row];
    scansView.scan = self.selectedScan;
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:[NSString stringWithFormat:@"%d", self.selectedScan.ID] forKey:@"scan_session_id"];
	[self performSelector:@selector(getScanSessions:) withObject:dict afterDelay:0.25];
}

- (void)getScanSessions:(NSMutableDictionary *)dict	{
	[self.serviceManager cancel];
    [self.serviceManager requestApi:@"scan_sessions/get_scans_by_scan_session_id" forClass:@"scan" usingObj:dict];
}


- (void) discloseDetails:(UIButton *)sender {
	NSLog(@"%@", sender.superview);
	
	ScanTableViewCell *cell = (ScanTableViewCell *) sender.superview;
    	
	if (_menuItemPopover == nil) {
		self.menuItemViewController = [[[MenuItemViewController alloc] initWithNibName:@"MenuItemViewController" bundle:nil] autorelease];
		_menuItemViewController.delegate = self;
		self.menuItemPopover = [[[UIPopoverController alloc] initWithContentViewController:_menuItemViewController] autorelease];
	}
	
	_menuItemViewController.index = cell.cellIndex;
	[self.menuItemPopover presentPopoverFromRect:cell.accessoryView.bounds inView:cell.accessoryView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}


#pragma mark ScanTableViewCellDelegate

- (void)editScanAtIndex:(int)_index {    
    [dropDownPopover dismissPopoverAnimated:YES];
	[_menuItemPopover dismissPopoverAnimated:YES];
    
    Scan *objScan = [scans objectAtIndex:_index];
    NewScanViewController *newScanVC = [[NewScanViewController alloc] initWithNibName:@"NewScanViewController" bundle:nil scanModel:objScan];
    newScanVC.delegate = self;
	[self.navigationController pushViewController:newScanVC animated:YES];
	[newScanVC release];
}



- (void)scanLocationAtIndex:(int)_index {
    [dropDownPopover dismissPopoverAnimated:YES];
	[_menuItemPopover dismissPopoverAnimated:YES];
    
    Scan *objScan = [scans objectAtIndex:_index];
    
    SessionLocationViewController *sessionLocationVC = [[SessionLocationViewController alloc] initWithNibName:@"SessionLocationViewController" bundle:nil scanModel:objScan];
    [self.navigationController pushViewController:sessionLocationVC animated:YES];
    [sessionLocationVC release];
}

- (void)createCheckInRecordWithRFID:(NSString *)rfid usingLocationID:(NSUInteger)locationID
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:rfid forKey:@"employee_rf_id"];
    [dictionary setObject:[NSNumber numberWithInt:locationID] forKey:@"location_id"];
    [dictionary setObject:[NSNumber numberWithInt:self.selectedScan.ID] forKey:@"scan_session_id"];
    [dictionary setObject:[NSString stringWithFormat:@"%f", [LocationManager getInstance].userLocation.coordinate.latitude] forKey:@"latitude"];
    [dictionary setObject:[NSString stringWithFormat:@"%f", [LocationManager getInstance].userLocation.coordinate.longitude] forKey:@"longitude"];
    [dictionary setObject:Shared.email forKey:@"created_by_email"];
    [self.serviceManager requestApi:@"employees/check_in" forClass:@"employee" usingObj:dictionary requestMethod:@"POST"];
}


#pragma mark Scans View Delegate 

- (void)scansViewDidSearchRfid:(NSString *)rfid {
    
	Location *bLocation = [Shared instance].baseLocation;
    NSLog(@"baseLocation id: %i", bLocation.ID);
        
    if (bLocation.ID) {
        
        CLLocation *baseLocation = [[[CLLocation alloc] initWithLatitude:[bLocation.latitude floatValue]
                                                              longitude:[bLocation.longitude floatValue]] autorelease];
        
        float distance = [[LocationManager getInstance] distanceFromLocation:baseLocation] / 1000;

        int locationID = 0;
        
        NSLog(@"Distance: %f, Shared Distance: %f", distance, Shared.distance);
        
        if (distance <= Shared.distance)	{
            locationID = bLocation.ID;            
        }
        
        if (locationID)	{
            NSArray *employees = scansView.scan.employees;
            if (employees.count)    {
                Employee *employee = [employees objectAtIndex:0];
                                
                if (locationID == employee.locationID)  
                {
                    [self createCheckInRecordWithRFID:rfid usingLocationID:locationID];
                }   
                else    
                {
                    [scansView.employeesTableView reloadData];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                                        message:@"The scan session has been locked because base location is changed." 
                                                                       delegate:nil 
                                                              cancelButtonTitle:@"OK" 
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
            }   
            else    
            {
                [self createCheckInRecordWithRFID:rfid usingLocationID:locationID];
            }
        }	
        else	
        {
            [scansView.employeesTableView reloadData];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                                message:@"You are out of range relative to base location." 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
        }
    }   
    else    
    {
        [scansView.employeesTableView reloadData];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                            message:@"Please add or select base location from settings." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
    
}


#pragma mark Email View Delegate

- (void)emailViewDidSearchEmail:(NSString *)email	{
    self.manualEmail = email;
	[self.serviceManager requestApi:@"employees/get_by_email" forClass:@"employee" usingObj:[NSDictionary dictionaryWithObject:email forKey:@"email_address"]];
}


#pragma mark Service Manager Delegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api {
    if ([api isEqualToString:@"scan_sessions/get_all"] || [api isEqualToString:@"scan_sessions/get_by_date_range"]) {
        
        [scans removeAllObjects];
        
        NSArray *arrScanSessions = [response objectForKey:@"scan_sessions"];
        for (NSDictionary *dict in arrScanSessions) {
            Emergency *objEmergency = [[Emergency alloc] initWithDictionary:[dict objectForKey:@"emergency"]];
            Scan *objScan = [[Scan alloc] initWithDictionary:dict];
            objScan.emergency = objEmergency;
            [scans addObject:objScan];
            [objEmergency release];
            [objScan release];
        }
        
		[scansTableView reloadData];
        [self.dropDownController.tableView reloadData];
		[self.scansTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
		[self tableView:scansTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.dropDownController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
		manualScanButton.hidden = (self.scans.count == 0);
    }	
    
    else if ([api isEqualToString:@"employees/check_in"])	{
		NSDictionary *employeeDictionary = [response objectForKey:@"employee"];
		Employee *employee = [[[Employee alloc] initWithDictionary:employeeDictionary] autorelease];
		[scansView addEmployee:employee];
	}
    
    else if ([api isEqualToString:@"employees/get_by_email"]) {
		[[DeviceManager currentDevice] enable];
        NSDictionary *employeeDictionary = [response objectForKey:@"employee"];
		Employee *employee = [[[Employee alloc] initWithDictionary:employeeDictionary] autorelease];
		[scansView setRfid:employee.rfid];
	}
    
    else if ([api isEqualToString:@"scan_sessions/get_scans_by_scan_session_id"]) {
        [self.selectedScan.employees removeAllObjects];
        NSArray *checkIns = [response objectForKey:@"scans"];
        for (NSDictionary *dict in checkIns) {
            Employee *objEmployee = [[Employee alloc] initWithDictionary:dict];
            [self.selectedScan.employees addObject:objEmployee];
            [objEmployee release];
        }
        scansView.scan = self.selectedScan;
    }
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api	{
	if ([api isEqualToString:@"employees/get_by_email"])	{
		if (code == 404)	{
			RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil cardNo:@"" employeeEmail:self.manualEmail isManualScan:YES];
			registerVC.delegate = self;
            [self.navigationController pushViewController:registerVC animated:YES];
            [registerVC release];
		}
        else if (code == 999) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Unknown Error" message:@"Invalid response from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
	}   
    else if ([api isEqualToString:@"scan_sessions/get_all"] || [api isEqualToString:@"scan_sessions/get_by_date_range"]) {
        if (code == 404){
            [scans removeAllObjects];
            [scansTableView reloadData];
            [scansView.scan.employees removeAllObjects];
            scansView.scan = nil;
            [scansView.employeesTableView reloadData];
            [self.dropDownController.tableView reloadData];
        }
        else if (code == 500) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:[response valueForKey:@"status"] 
                                                               message:[response valueForKey:@"message"] 
                                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alerView show];
            [alerView release];
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


#pragma mark New Scan View Controller Delegate

- (void)reloadScans {
	[[DeviceManager currentDevice] enable];
    
    if ([Shared isNetworkAvailable]) {
        NSString *postfix = nil;
        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
        if ([Shared instance].fromDate == nil || [Shared instance].toDate == nil)   {
            postfix = @"all";
        }   else    {
            postfix = @"by_date_range";
            [dict setValue:[[Shared instance].fromDate rfc3339String] forKey:@"start_date"];
            [dict setValue:[[Shared instance].toDate rfc3339String] forKey:@"end_date"];
        }
        [dict setObject:Shared.email forKey:@"created_by_email"];
        [self.serviceManager requestApi:[NSString stringWithFormat:@"scan_sessions/get_%@", postfix]
                               forClass:@"scan" 
                               usingObj:dict];
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}


#pragma mark Popover Delegate
- (void)itemSelected:(Scan *)item selectedIndex:(int)index {
    [self.dropDownPopover dismissPopoverAnimated:YES];
    [scansTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:scansTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark TableRootViewControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController   {
    [self reloadScans];
}

@end
